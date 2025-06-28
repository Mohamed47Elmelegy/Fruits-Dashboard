import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole { customer, admin, unknown }

class UserRoleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user's role
  Future<UserRole> getCurrentUserRole() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return UserRole.unknown;

      // Check if user is admin
      final adminDoc =
          await _firestore.collection('admins').doc(user.uid).get();
      if (adminDoc.exists) {
        return UserRole.admin;
      }

      // Check if user is customer
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserRole.customer;
      }

      return UserRole.unknown;
    } catch (e) {
      print('Error getting user role: $e');
      return UserRole.unknown;
    }
  }

  /// Check if current user is admin
  Future<bool> isAdmin() async {
    return await getCurrentUserRole() == UserRole.admin;
  }

  /// Check if current user is customer
  Future<bool> isCustomer() async {
    return await getCurrentUserRole() == UserRole.customer;
  }

  /// Create or update user profile
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String name,
    UserRole role = UserRole.customer,
  }) async {
    try {
      final userData = {
        'uid': uid,
        'email': email,
        'name': name,
        'role': role.name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add to users collection
      await _firestore.collection('users').doc(uid).set(userData);

      // If admin, also add to admins collection
      if (role == UserRole.admin) {
        await _firestore.collection('admins').doc(uid).set({
          'uid': uid,
          'email': email,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
  }

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  /// Delete user profile
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      await _firestore.collection('admins').doc(uid).delete();
    } catch (e) {
      print('Error deleting user profile: $e');
      rethrow;
    }
  }
}
