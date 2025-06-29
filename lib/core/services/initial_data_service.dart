import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/firebase_collections.dart';
import '../config/ansicolor.dart';

class InitialDataService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Initialize app with required data structures
  static Future<void> initializeAppData() async {
    try {
      DebugConsoleMessages.info('🚀 Initializing app data...');

      // Create admin user if not exists
      await _createAdminUser();

      // Create app settings if not exists
      await _createAppSettings();

      // Create sample products if not exists
      await _createSampleProducts();

      DebugConsoleMessages.success('✅ App data initialization completed');
    } catch (e) {
      DebugConsoleMessages.error('❌ Error initializing app data: $e');
    }
  }

  /// Create admin user in Firestore
  static Future<void> _createAdminUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        DebugConsoleMessages.warning(
            '⚠️ No authenticated user found for admin creation');
        return;
      }

      final adminDoc = await _firestore
          .collection(FirebaseCollections.admins)
          .doc(user.uid)
          .get();

      if (!adminDoc.exists) {
        await _firestore
            .collection(FirebaseCollections.admins)
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'email': user.email,
          'name': 'Mohamed Admin',
          'role': 'admin',
          'isActive': true,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        DebugConsoleMessages.success('✅ Admin user created: ${user.uid}');
      } else {
        DebugConsoleMessages.info('ℹ️ Admin user already exists: ${user.uid}');
      }
    } catch (e) {
      DebugConsoleMessages.error('❌ Error creating admin user: $e');
    }
  }

  /// Create app settings
  static Future<void> _createAppSettings() async {
    try {
      final settingsDoc = await _firestore
          .collection(FirebaseCollections.appSettings)
          .doc('general')
          .get();

      if (!settingsDoc.exists) {
        await _firestore
            .collection(FirebaseCollections.appSettings)
            .doc('general')
            .set({
          'appName': 'Fruit App Dashboard',
          'version': '1.0.5',
          'maintenanceMode': false,
          'deliveryFee': 5.0,
          'minOrderAmount': 10.0,
          'currency': 'USD',
          'supportEmail': 'support@furute.com',
          'supportPhone': '+1234567890',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        DebugConsoleMessages.success('✅ App settings created');
      } else {
        DebugConsoleMessages.info('ℹ️ App settings already exist');
      }
    } catch (e) {
      DebugConsoleMessages.error('❌ Error creating app settings: $e');
    }
  }

  /// Create sample products
  static Future<void> _createSampleProducts() async {
    try {
      final productsQuery = await _firestore
          .collection(FirebaseCollections.products)
          .limit(1)
          .get();

      if (productsQuery.docs.isEmpty) {
        final sampleProducts = [
          {
            'productName': 'تفاح أحمر',
            'productPrice': 2.99,
            'productCode': 'APP001',
            'productDescription': 'تفاح أحمر طازج عضوي من أفضل المزارع',
            'isFeatured': true,
            'isActive': true,
            'category': 'fruits',
            'calories': 95,
            'unitAmount': '1 kg',
            'productRating': 4.5,
            'ratingCount': 10,
            'isOrganic': true,
            'imageUrl':
                'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
            'sellingCount': 0,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'createdBy': _auth.currentUser?.uid,
          },
          {
            'productName': 'موز أصفر',
            'productPrice': 1.99,
            'productCode': 'BAN002',
            'productDescription': 'موز أصفر طازج غني بالبوتاسيوم',
            'isFeatured': true,
            'isActive': true,
            'category': 'fruits',
            'calories': 105,
            'unitAmount': '1 kg',
            'productRating': 4.3,
            'ratingCount': 8,
            'isOrganic': false,
            'imageUrl':
                'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=400',
            'sellingCount': 0,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'createdBy': _auth.currentUser?.uid,
          },
          {
            'productName': 'برتقال حلو',
            'productPrice': 3.49,
            'productCode': 'ORA003',
            'productDescription': 'برتقال حلو غني بفيتامين C',
            'isFeatured': false,
            'isActive': true,
            'category': 'fruits',
            'calories': 62,
            'unitAmount': '1 kg',
            'productRating': 4.7,
            'ratingCount': 15,
            'isOrganic': true,
            'imageUrl':
                'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
            'sellingCount': 0,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'createdBy': _auth.currentUser?.uid,
          },
        ];

        for (final product in sampleProducts) {
          await _firestore
              .collection(FirebaseCollections.products)
              .add(product);
        }
        DebugConsoleMessages.success('✅ Sample products created');
      } else {
        DebugConsoleMessages.info('ℹ️ Products already exist');
      }
    } catch (e) {
      DebugConsoleMessages.error('❌ Error creating sample products: $e');
    }
  }

  /// Check if app is properly configured
  static Future<bool> isAppConfigured() async {
    try {
      // Check if admin exists
      final user = _auth.currentUser;
      if (user == null) return false;

      final adminDoc = await _firestore
          .collection(FirebaseCollections.admins)
          .doc(user.uid)
          .get();

      if (!adminDoc.exists) return false;

      // Check if app settings exist
      final settingsDoc = await _firestore
          .collection(FirebaseCollections.appSettings)
          .doc('general')
          .get();

      if (!settingsDoc.exists) return false;

      // Check if products exist
      final productsQuery = await _firestore
          .collection(FirebaseCollections.products)
          .limit(1)
          .get();

      return productsQuery.docs.isNotEmpty;
    } catch (e) {
      DebugConsoleMessages.error('❌ Error checking app configuration: $e');
      return false;
    }
  }

  /// Get app configuration status
  static Future<Map<String, bool>> getConfigurationStatus() async {
    try {
      final user = _auth.currentUser;
      final hasUser = user != null;

      bool hasAdmin = false;
      bool hasSettings = false;
      bool hasProducts = false;

      if (hasUser) {
        // Check admin
        final adminDoc = await _firestore
            .collection(FirebaseCollections.admins)
            .doc(user.uid)
            .get();
        hasAdmin = adminDoc.exists;

        // Check settings
        final settingsDoc = await _firestore
            .collection(FirebaseCollections.appSettings)
            .doc('general')
            .get();
        hasSettings = settingsDoc.exists;

        // Check products
        final productsQuery = await _firestore
            .collection(FirebaseCollections.products)
            .limit(1)
            .get();
        hasProducts = productsQuery.docs.isNotEmpty;
      }

      return {
        'hasUser': hasUser,
        'hasAdmin': hasAdmin,
        'hasSettings': hasSettings,
        'hasProducts': hasProducts,
      };
    } catch (e) {
      DebugConsoleMessages.error('❌ Error getting configuration status: $e');
      return {
        'hasUser': false,
        'hasAdmin': false,
        'hasSettings': false,
        'hasProducts': false,
      };
    }
  }
}
