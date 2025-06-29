import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../constants/firebase_collections.dart';
import '../constants/constants.dart';
import 'supabase_init_service.dart';

class ProductIntegrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SupabaseClient? _supabaseClient;

  // Constructor - no Supabase access here
  ProductIntegrationService();

  // Get Supabase client with lazy initialization
  SupabaseClient get _supabase {
    if (_supabaseClient == null) {
      _supabaseClient = SupabaseInitService.getClient();
    }
    return _supabaseClient!;
  }

  /// Add new product from admin dashboard
  Future<String> addProduct(
      Map<String, dynamic> productData, File? imageFile) async {
    try {
      print('🚀 Starting to add product...');
      print('📦 Product data: $productData');

      String? imageUrl;

      // Upload image if provided
      if (imageFile != null) {
        print('📸 Uploading image...');
        imageUrl =
            await _uploadProductImage(imageFile, productData['productCode']);
        print('✅ Image uploaded successfully: $imageUrl');
      } else {
        print('ℹ️ No image provided');
      }

      // Add image URL to product data
      if (imageUrl != null) {
        productData['imageUrl'] = imageUrl;
      }

      // Add timestamps
      productData['createdAt'] = FieldValue.serverTimestamp();
      productData['updatedAt'] = FieldValue.serverTimestamp();
      productData['isActive'] = true;

      print(
          '🔥 Adding to Firestore collection: ${FirebaseCollections.products}');

      // Add to Firestore
      final docRef = await _firestore
          .collection(FirebaseCollections.products)
          .add(productData);

      print('✅ Product added successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('❌ Error adding product: $e');
      print('🔍 Error type: ${e.runtimeType}');
      print('📋 Product data that failed: $productData');
      rethrow;
    }
  }

  /// Update existing product
  Future<void> updateProduct(String productId, Map<String, dynamic> productData,
      File? imageFile) async {
    try {
      // Upload new image if provided
      if (imageFile != null) {
        final imageUrl =
            await _uploadProductImage(imageFile, productData['productCode']);
        productData['imageUrl'] = imageUrl;
      }

      // Update timestamp
      productData['updatedAt'] = FieldValue.serverTimestamp();

      // Update in Firestore
      await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .update(productData);
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  /// Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      // Soft delete - mark as inactive
      await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error deleting product: $e');
      rethrow;
    }
  }

  /// Get all active products for customer app
  Future<List<Map<String, dynamic>>> getActiveProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.products)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error getting active products: $e');
      rethrow;
    }
  }

  /// Get featured products
  Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.products)
          .where('isActive', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .orderBy('sellingCount', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error getting featured products: $e');
      rethrow;
    }
  }

  /// Get best selling products
  Future<List<Map<String, dynamic>>> getBestSellingProducts(
      {int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.products)
          .where('isActive', isEqualTo: true)
          .orderBy('sellingCount', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      print('Error getting best selling products: $e');
      rethrow;
    }
  }

  /// Update product selling count
  Future<void> updateProductSellingCount(String productId, int quantity) async {
    try {
      await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .update({
        'sellingCount': FieldValue.increment(quantity),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating product selling count: $e');
      rethrow;
    }
  }

  /// Upload product image to Supabase Storage
  Future<String> _uploadProductImage(File imageFile, String productCode) async {
    try {
      final fileName =
          '${productCode}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'products/images/$fileName';

      // Upload file to Supabase Storage using correct bucket name
      await _supabase.storage
          .from(Constatns.supabaseBucket)
          .upload(filePath, imageFile);

      // Get public URL
      final imageUrl = _supabase.storage
          .from(Constatns.supabaseBucket)
          .getPublicUrl(filePath);

      return imageUrl;
    } catch (e) {
      print('Error uploading product image: $e');
      rethrow;
    }
  }

  /// Search products by name or description
  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      // Note: Firestore doesn't support full-text search natively
      // This is a simple implementation - consider using Algolia for better search
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.products)
          .where('isActive', isEqualTo: true)
          .get();

      final products = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();

      // Filter by query (case-insensitive)
      return products.where((product) {
        final name = product['productName']?.toString().toLowerCase() ?? '';
        final description =
            product['productDescription']?.toString().toLowerCase() ?? '';
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) || description.contains(searchQuery);
      }).toList();
    } catch (e) {
      print('Error searching products: $e');
      rethrow;
    }
  }

  /// Get all products for admin dashboard
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.products)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        // Handle field mapping from Firebase to our expected format
        return {
          'id': doc.id,
          'productName': data['productName'],
          'productPrice': data['productPrice'],
          'productCode': data['productCode'],
          'productDescription': data['productDescription'],
          'isFeatured': data['isFeatured'] ?? false,
          'imageUrl': data['imageUrl'],
          'expiryDateMonths': data['expiryDateMonths'],
          'calorieDensity': data['calories'] ??
              data['calorieDensity'], // Handle both field names
          'unitAmount':
              data['unitAmount']?.toString() ?? '0', // Convert back to string
          'productRating': data['productRating'] ?? 0,
          'ratingCount': data['ratingCount'] ?? 0,
          'isOrganic': data['isOrganic'] ?? false,
          'reviews': data['reviews'] ?? [],
          'sellingCount': data['sellingCount'] ?? 0,
          'createdAt': data['createdAt'],
          'updatedAt': data['updatedAt'],
          'isActive': data['isActive'] ?? true,
        };
      }).toList();
    } catch (e) {
      print('Error getting all products: $e');
      rethrow;
    }
  }

  /// Get product by ID
  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .get();

      if (doc.exists) {
        return {
          'id': doc.id,
          ...doc.data()!,
        };
      }
      return null;
    } catch (e) {
      print('Error getting product by ID: $e');
      rethrow;
    }
  }
}
