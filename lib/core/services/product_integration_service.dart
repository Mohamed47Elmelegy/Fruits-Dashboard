import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../config/ansicolor.dart';
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
      log(DebugConsoleMessages.info('Initializing Supabase client'));
      _supabaseClient = SupabaseInitService.getClient();
    }
    return _supabaseClient!;
  }

  /// Add new product from admin dashboard
  Future<String> addProduct(
      Map<String, dynamic> productData, File? imageFile) async {
    try {
      log(DebugConsoleMessages.info('Starting to add product...'));
      log(DebugConsoleMessages.info('📦 Product data: $productData'));

      String? imageUrl;

      // Upload image if provided
      if (imageFile != null) {
        log(DebugConsoleMessages.info('📸 Uploading image...'));
        imageUrl =
            await _uploadProductImage(imageFile, productData['productCode']);
        log(DebugConsoleMessages.success(
            '✅ Image uploaded successfully: $imageUrl'));
      } else {
        log(DebugConsoleMessages.info('ℹ️ No image provided'));
      }

      // Add image URL to product data
      if (imageUrl != null) {
        productData['imageUrl'] = imageUrl;
      }

      // Add timestamps
      productData['createdAt'] = FieldValue.serverTimestamp();
      productData['updatedAt'] = FieldValue.serverTimestamp();
      productData['isActive'] = true;

      log(DebugConsoleMessages.info(
          '🔥 Adding to Firestore collection: ${FirebaseCollections.products}'));

      // Add to Firestore
      final docRef = await _firestore
          .collection(FirebaseCollections.products)
          .add(productData);

      log(DebugConsoleMessages.success(
          '✅ Product added successfully with ID: ${docRef.id}'));
      return docRef.id;
    } catch (e) {
      log(DebugConsoleMessages.error('❌ Error adding product: $e'));
      log(DebugConsoleMessages.info('🔍 Error type: ${e.runtimeType}'));
      log(DebugConsoleMessages.info(
          '📋 Product data that failed: $productData'));
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
      log(DebugConsoleMessages.error('Error updating product: $e'));
      rethrow;
    }
  }

  /// Delete product (Soft Delete - mark as inactive)
  Future<void> deleteProduct(String productId) async {
    try {
      log(DebugConsoleMessages.info(
          '🗑️ Starting to soft delete product with ID: $productId'));

      // First check if product exists
      final doc = await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .get();

      if (!doc.exists) {
        throw Exception('Product not found with ID: $productId');
      }

      // Soft delete - mark as inactive
      await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .update({
        'isActive': false,
        'deletedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      log(DebugConsoleMessages.success(
          '✅ Product soft deleted successfully: $productId'));
    } catch (e) {
      log(DebugConsoleMessages.error('❌ Error soft deleting product: $e'));
      rethrow;
    }
  }

  /// Hard delete product (completely remove from Firebase)
  Future<void> hardDeleteProduct(String productId) async {
    try {
      log(DebugConsoleMessages.info(
          '🗑️ Starting to hard delete product with ID: $productId'));

      // First check if product exists
      final doc = await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .get();

      if (!doc.exists) {
        throw Exception('Product not found with ID: $productId');
      }

      // Hard delete - completely remove the document
      await _firestore
          .collection(FirebaseCollections.products)
          .doc(productId)
          .delete();

      log(DebugConsoleMessages.success(
          '✅ Product hard deleted successfully: $productId'));
    } catch (e) {
      log(DebugConsoleMessages.error('❌ Error hard deleting product: $e'));
      rethrow;
    }
  }

  /// Get all active products for customer app
  Future<List<Map<String, dynamic>>> getActiveProducts() async {
    try {
      // Get products without ordering to avoid index requirement
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

      // Sort by createdAt in descending order (newest first)
      products.sort((a, b) {
        final aCreatedAt = a['createdAt'] as Timestamp?;
        final bCreatedAt = b['createdAt'] as Timestamp?;

        if (aCreatedAt == null && bCreatedAt == null) return 0;
        if (aCreatedAt == null) return 1;
        if (bCreatedAt == null) return -1;

        return bCreatedAt.compareTo(aCreatedAt); // Descending order
      });

      return products;
    } catch (e) {
      log(DebugConsoleMessages.error('Error getting active products: $e'));
      rethrow;
    }
  }

  /// Get featured products
  Future<List<Map<String, dynamic>>> getFeaturedProducts() async {
    try {
      // Get featured products without ordering to avoid index requirement
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.products)
          .where('isActive', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .get();

      final products = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();

      // Sort by sellingCount in descending order and limit to 10
      products.sort((a, b) {
        final aSellingCount = a['sellingCount'] as int? ?? 0;
        final bSellingCount = b['sellingCount'] as int? ?? 0;
        return bSellingCount.compareTo(aSellingCount); // Descending order
      });

      // Limit to 10 products
      if (products.length > 10) {
        return products.take(10).toList();
      }

      return products;
    } catch (e) {
      log(DebugConsoleMessages.error('Error getting featured products: $e'));
      rethrow;
    }
  }

  /// Get best selling products
  Future<List<Map<String, dynamic>>> getBestSellingProducts(
      {int limit = 10}) async {
    try {
      // Get active products without ordering to avoid index requirement
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

      // Sort by sellingCount in descending order
      products.sort((a, b) {
        final aSellingCount = a['sellingCount'] as int? ?? 0;
        final bSellingCount = b['sellingCount'] as int? ?? 0;
        return bSellingCount.compareTo(aSellingCount); // Descending order
      });

      // Limit to specified number of products
      if (products.length > limit) {
        return products.take(limit).toList();
      }

      return products;
    } catch (e) {
      log(DebugConsoleMessages.error(
          'Error getting best selling products: $e'));
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
      log(DebugConsoleMessages.error(
          'Error updating product selling count: $e'));
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
      log(DebugConsoleMessages.error('Error uploading product image: $e'));
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
      log(DebugConsoleMessages.error('Error searching products: $e'));
      rethrow;
    }
  }

  /// Get all products for admin dashboard
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      // First get all products without ordering to avoid index requirement
      final querySnapshot = await _firestore
          .collection(FirebaseCollections.products)
          .where('isActive', isEqualTo: true) // Only get active products
          .get();

      // Then sort them in memory
      final products = querySnapshot.docs.map((doc) {
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

      // Sort by createdAt in descending order (newest first)
      products.sort((a, b) {
        final aCreatedAt = a['createdAt'] as Timestamp?;
        final bCreatedAt = b['createdAt'] as Timestamp?;

        if (aCreatedAt == null && bCreatedAt == null) return 0;
        if (aCreatedAt == null) return 1;
        if (bCreatedAt == null) return -1;

        return bCreatedAt.compareTo(aCreatedAt); // Descending order
      });

      return products;
    } catch (e) {
      log(DebugConsoleMessages.error('Error getting all products: $e'));
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
      log(DebugConsoleMessages.error('Error getting product by ID: $e'));
      rethrow;
    }
  }
}
