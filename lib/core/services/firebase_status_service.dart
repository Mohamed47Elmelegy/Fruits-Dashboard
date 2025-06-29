import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'initial_data_service.dart';
import '../config/ansicolor.dart';

class FirebaseStatusService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get comprehensive Firebase status
  static Future<Map<String, dynamic>> getFirebaseStatus() async {
    try {
      final status = {
        'timestamp': DateTime.now().toIso8601String(),
        'firebase_initialized': true,
        'authentication': await _checkAuthentication(),
        'firestore': await _checkFirestore(),
        'app_configuration': await InitialDataService.getConfigurationStatus(),
        'user_info': await _getUserInfo(),
      };

      return status;
    } catch (e) {
      return {
        'timestamp': DateTime.now().toIso8601String(),
        'error': e.toString(),
        'firebase_initialized': false,
      };
    }
  }

  /// Check authentication status
  static Future<Map<String, dynamic>> _checkAuthentication() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {
          'status': 'not_authenticated',
          'message': 'No user is currently signed in',
        };
      }

      return {
        'status': 'authenticated',
        'user_id': user.uid,
        'email': user.email,
        'email_verified': user.emailVerified,
        'creation_time': user.metadata.creationTime?.toIso8601String(),
        'last_sign_in': user.metadata.lastSignInTime?.toIso8601String(),
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  /// Check Firestore connection and basic operations
  static Future<Map<String, dynamic>> _checkFirestore() async {
    try {
      // Test basic read operation
      final testDoc = await _firestore.collection('test').add({
        'test': 'connection_check',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Test read operation
      final docSnapshot = await testDoc.get();

      // Clean up
      await testDoc.delete();

      return {
        'status': 'connected',
        'write_test': 'success',
        'read_test': 'success',
        'delete_test': 'success',
        'test_document_id': testDoc.id,
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  /// Get current user information
  static Future<Map<String, dynamic>> _getUserInfo() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return {
          'status': 'no_user',
        };
      }

      // Get admin status
      final adminDoc =
          await _firestore.collection('admins').doc(user.uid).get();

      final isAdmin = adminDoc.exists;
      final adminData = adminDoc.exists ? adminDoc.data() : null;

      return {
        'status': 'user_found',
        'uid': user.uid,
        'email': user.email,
        'is_admin': isAdmin,
        'admin_data': adminData,
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  /// Print comprehensive status to console
  static Future<void> printFirebaseStatus() async {
    try {
      DebugConsoleMessages.info('\n🔥 Firebase Status Report 🔥');
      DebugConsoleMessages.info('=' * 50);

      final status = await getFirebaseStatus();

      // Timestamp
      DebugConsoleMessages.info('📅 Timestamp: ${status['timestamp']}');
      DebugConsoleMessages.info('');

      // Firebase Initialization
      final isInitialized = status['firebase_initialized'] == true;
      DebugConsoleMessages.info(
          '🚀 Firebase Initialized: ${isInitialized ? '✅' : '❌'}');
      DebugConsoleMessages.info('');

      // Authentication Status
      final auth = status['authentication'] as Map<String, dynamic>;
      DebugConsoleMessages.info('🔐 Authentication Status: ${auth['status']}');
      if (auth['status'] == 'authenticated') {
        DebugConsoleMessages.success('   👤 User ID: ${auth['user_id']}');
        DebugConsoleMessages.success('   📧 Email: ${auth['email']}');
        DebugConsoleMessages.success(
            '   ✅ Email Verified: ${auth['email_verified']}');
      }
      DebugConsoleMessages.info('');

      // Firestore Status
      final firestore = status['firestore'] as Map<String, dynamic>;
      DebugConsoleMessages.info('📊 Firestore Status: ${firestore['status']}');
      if (firestore['status'] == 'connected') {
        DebugConsoleMessages.success(
            '   ✍️ Write Test: ${firestore['write_test']}');
        DebugConsoleMessages.success(
            '   📖 Read Test: ${firestore['read_test']}');
        DebugConsoleMessages.success(
            '   🗑️ Delete Test: ${firestore['delete_test']}');
      }
      DebugConsoleMessages.info('');

      // App Configuration
      final config = status['app_configuration'] as Map<String, bool>;
      DebugConsoleMessages.info('⚙️ App Configuration:');
      DebugConsoleMessages.info(
          '   👤 Has User: ${config['hasUser'] == true ? '✅' : '❌'}');
      DebugConsoleMessages.info(
          '   👑 Has Admin: ${config['hasAdmin'] == true ? '✅' : '❌'}');
      DebugConsoleMessages.info(
          '   ⚙️ Has Settings: ${config['hasSettings'] == true ? '✅' : '❌'}');
      DebugConsoleMessages.info(
          '   🍎 Has Products: ${config['hasProducts'] == true ? '✅' : '❌'}');
      DebugConsoleMessages.info('');

      // User Info
      final userInfo = status['user_info'] as Map<String, dynamic>;
      DebugConsoleMessages.info('👤 User Information:');
      DebugConsoleMessages.info('   Status: ${userInfo['status']}');
      if (userInfo['status'] == 'user_found') {
        DebugConsoleMessages.success('   UID: ${userInfo['uid']}');
        DebugConsoleMessages.success('   Email: ${userInfo['email']}');
        DebugConsoleMessages.success(
            '   Is Admin: ${userInfo['is_admin'] == true ? '✅' : '❌'}');
      }

      DebugConsoleMessages.info('=' * 50);
      DebugConsoleMessages.info('');
    } catch (e) {
      DebugConsoleMessages.error('❌ Error printing Firebase status: $e');
    }
  }

  /// Check if Firebase is ready for production
  static Future<bool> isFirebaseReady() async {
    try {
      final status = await getFirebaseStatus();

      // Check basic requirements
      if (status['firebase_initialized'] != true) return false;

      final auth = status['authentication'] as Map<String, dynamic>;
      if (auth['status'] != 'authenticated') return false;

      final firestore = status['firestore'] as Map<String, dynamic>;
      if (firestore['status'] != 'connected') return false;

      final config = status['app_configuration'] as Map<String, bool>;
      if (config['hasUser'] != true ||
          config['hasAdmin'] != true ||
          config['hasSettings'] != true) return false;

      return true;
    } catch (e) {
      DebugConsoleMessages.error('❌ Error checking Firebase readiness: $e');
      return false;
    }
  }

  /// Get detailed error information if Firebase is not ready
  static Future<List<String>> getFirebaseIssues() async {
    final issues = <String>[];

    try {
      final status = await getFirebaseStatus();

      if (status['firebase_initialized'] != true) {
        issues.add('Firebase is not initialized');
      }

      final auth = status['authentication'] as Map<String, dynamic>;
      if (auth['status'] != 'authenticated') {
        final message =
            auth['message'] ?? auth['error'] ?? 'Unknown authentication error';
        issues.add('Authentication failed: $message');
      }

      final firestore = status['firestore'] as Map<String, dynamic>;
      if (firestore['status'] != 'connected') {
        final error = firestore['error'] ?? 'Unknown Firestore error';
        issues.add('Firestore connection failed: $error');
      }

      final config = status['app_configuration'] as Map<String, bool>;
      if (config['hasUser'] != true) {
        issues.add('No authenticated user found');
      }
      if (config['hasAdmin'] != true) {
        issues.add('Admin user not configured');
      }
      if (config['hasSettings'] != true) {
        issues.add('App settings not configured');
      }
      if (config['hasProducts'] != true) {
        issues.add('No products found (optional)');
      }
    } catch (e) {
      issues.add('Error checking Firebase status: $e');
    }

    return issues;
  }
}
