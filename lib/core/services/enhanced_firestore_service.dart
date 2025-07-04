import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/firebase_collections.dart';

class EnhancedFirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Enable offline persistence for iOS
  static Future<void> initialize() async {
    try {
      // Enable offline persistence
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      print('✅ Firestore initialized with offline persistence');
    } catch (e) {
      print('❌ Error initializing Firestore: $e');
    }
  }

  // MARK: - Product Operations

  /// Add product with enhanced error handling
  static Future<String> addProduct(Map<String, dynamic> productData) async {
    try {
      // Add metadata
      productData['createdAt'] = FieldValue.serverTimestamp();
      productData['updatedAt'] = FieldValue.serverTimestamp();
      productData['createdBy'] = _auth.currentUser?.uid;
      productData['isActive'] = true;

      final docRef = await _firestore
          .collection(FirebaseCollections.products)
          .add(productData);

      print('✅ Product added successfully: ${docRef.id}');
      return docRef.id;
    } on FirebaseException catch (e) {
      print('❌ Firebase error adding product: ${e.code} - ${e.message}');
      throw _handleFirebaseError(e);
    } catch (e) {
      print('❌ Unexpected error adding product: $e');
      rethrow;
    }
  }

  /// Get products with pagination and caching
  static Future<List<Map<String, dynamic>>> getProducts({
    int limit = 20,
    DocumentSnapshot? lastDocument,
    bool activeOnly = true,
  }) async {
    try {
      Query query = _firestore
          .collection(FirebaseCollections.products)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (activeOnly) {
        query = query.where('isActive', isEqualTo: true);
      }

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return <String, dynamic>{
          'id': doc.id,
          ...data,
        };
      }).toList();
    } on FirebaseException catch (e) {
      print('❌ Firebase error getting products: ${e.code} - ${e.message}');
      throw _handleFirebaseError(e);
    } catch (e) {
      print('❌ Unexpected error getting products: $e');
      rethrow;
    }
  }

  /// Update product with optimistic updates
  static Future<void> updateProduct(
    String productId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      updates['updatedBy'] = _auth.currentUser?.uid;

      await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .update(updates);

      print('✅ Product updated successfully: $productId');
    } on FirebaseException catch (e) {
      print('❌ Firebase error updating product: ${e.code} - ${e.message}');
      throw _handleFirebaseError(e);
    } catch (e) {
      print('❌ Unexpected error updating product: $e');
      rethrow;
    }
  }

  // MARK: - Order Operations

  /// Create order with transaction
  static Future<String> createOrder(Map<String, dynamic> orderData) async {
    try {
      return await _firestore.runTransaction<String>((transaction) async {
        // Add order metadata
        orderData['createdAt'] = FieldValue.serverTimestamp();
        orderData['updatedAt'] = FieldValue.serverTimestamp();
        orderData['userId'] = _auth.currentUser?.uid;
        orderData['status'] = 'pending';
        orderData['orderNumber'] = await _generateOrderNumber();

        // Create order document
        final orderRef =
            _firestore.collection(FirebaseCollections.orders).doc();
        transaction.set(orderRef, orderData);

        // Update user's order count
        final userRef = _firestore
            .collection(FirebaseCollections.users)
            .doc(_auth.currentUser?.uid);
        transaction.update(userRef, {
          'orderCount': FieldValue.increment(1),
          'lastOrderAt': FieldValue.serverTimestamp(),
        });

        return orderRef.id;
      });
    } on FirebaseException catch (e) {
      print('❌ Firebase error creating order: ${e.code} - ${e.message}');
      throw _handleFirebaseError(e);
    } catch (e) {
      print('❌ Unexpected error creating order: $e');
      rethrow;
    }
  }

  /// Get orders with real-time updates
  static Stream<List<Map<String, dynamic>>> getOrdersStream({
    String? userId,
    String? status,
  }) {
    try {
      Query query = _firestore
          .collection(FirebaseCollections.orders)
          .orderBy('createdAt', descending: true);

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return <String, dynamic>{
            'id': doc.id,
            ...data,
          };
        }).toList();
      });
    } on FirebaseException catch (e) {
      print('❌ Firebase error getting orders stream: ${e.code} - ${e.message}');
      throw _handleFirebaseError(e);
    } catch (e) {
      print('❌ Unexpected error getting orders stream: $e');
      rethrow;
    }
  }

  // MARK: - User Operations

  /// Create or update user profile
  static Future<void> upsertUserProfile(Map<String, dynamic> userData) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      userData['updatedAt'] = FieldValue.serverTimestamp();
      userData['lastLoginAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .set(userData, SetOptions(merge: true));

      print('✅ User profile updated successfully: $userId');
    } on FirebaseException catch (e) {
      print('❌ Firebase error updating user profile: ${e.code} - ${e.message}');
      throw _handleFirebaseError(e);
    } catch (e) {
      print('❌ Unexpected error updating user profile: $e');
      rethrow;
    }
  }

  /// Get user profile with caching
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.users)
          .doc(userId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          return <String, dynamic>{
            'id': doc.id,
            ...data,
          };
        }
      }
      return null;
    } on FirebaseException catch (e) {
      print('❌ Firebase error getting user profile: ${e.code} - ${e.message}');
      throw _handleFirebaseError(e);
    } catch (e) {
      print('❌ Unexpected error getting user profile: $e');
      rethrow;
    }
  }

  // MARK: - Analytics and Statistics

  /// Track app usage analytics
  static Future<void> trackEvent(
      String eventName, Map<String, dynamic> parameters) async {
    try {
      final eventData = {
        'eventName': eventName,
        'parameters': parameters,
        'userId': _auth.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': 'iOS',
      };

      await _firestore.collection('analytics').add(eventData);

      print('✅ Event tracked: $eventName');
    } catch (e) {
      print('❌ Error tracking event: $e');
      // Don't throw - analytics failures shouldn't break the app
    }
  }

  /// Get sales statistics
  static Future<Map<String, dynamic>> getSalesStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore.collection(FirebaseCollections.orders);

      if (startDate != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: endDate);
      }

      final querySnapshot = await query.get();

      double totalRevenue = 0;
      int totalOrders = querySnapshot.docs.length;
      Map<String, int> statusCounts = {};

      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalRevenue += (data['total'] ?? 0).toDouble();

        final status = data['status'] ?? 'unknown';
        statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      }

      return {
        'totalRevenue': totalRevenue,
        'totalOrders': totalOrders,
        'statusCounts': statusCounts,
        'averageOrderValue': totalOrders > 0 ? totalRevenue / totalOrders : 0,
      };
    } on FirebaseException catch (e) {
      print('❌ Firebase error getting sales stats: ${e.code} - ${e.message}');
      throw _handleFirebaseError(e);
    } catch (e) {
      print('❌ Unexpected error getting sales stats: $e');
      rethrow;
    }
  }

  // MARK: - Utility Methods

  /// Generate unique order number
  static Future<String> _generateOrderNumber() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'ORD-$timestamp-$random';
  }

  /// Handle Firebase errors with user-friendly messages
  static Exception _handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return Exception('Access denied. Please check your permissions.');
      case 'unavailable':
        return Exception('Service temporarily unavailable. Please try again.');
      case 'not-found':
        return Exception('The requested data was not found.');
      case 'already-exists':
        return Exception('This item already exists.');
      case 'resource-exhausted':
        return Exception('Service quota exceeded. Please try again later.');
      case 'failed-precondition':
        return Exception('Operation failed due to a precondition.');
      case 'aborted':
        return Exception('Operation was aborted. Please try again.');
      case 'out-of-range':
        return Exception('Operation is out of valid range.');
      case 'unimplemented':
        return Exception('Operation is not implemented.');
      case 'internal':
        return Exception('Internal error occurred. Please try again.');
      case 'data-loss':
        return Exception('Data loss occurred. Please try again.');
      case 'unauthenticated':
        return Exception('Authentication required. Please sign in.');
      default:
        return Exception('An error occurred: ${e.message}');
    }
  }

  /// Clear local cache (useful for testing)
  static Future<void> clearCache() async {
    try {
      await _firestore.clearPersistence();
      print('✅ Firestore cache cleared');
    } catch (e) {
      print('❌ Error clearing cache: $e');
    }
  }
}
