import 'dart:io';

import 'package:furute_app_dashbord/Features/AddProudcuts/Data/model/reviews_model.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/add_proudcuts_entity.dart';

class ProductModel {
  final String productName;
  final num productPrice;
  final String productCode;
  final String productDescription;
  final File productImage;
  final bool isFeatured;
  String? imageUrl;
  final int expiryDateMonths;
  final int calorieDensity;
  final int caloriesReferenceWeight;
  final num productRating;
  final num ratingCount;
  final bool isOrganic;
  final List<ReviewsModel> reviews;
  ProductModel({
    required this.expiryDateMonths,
    required this.calorieDensity,
    required this.caloriesReferenceWeight,
    this.productRating = 0,
    this.ratingCount = 0,
    required this.productDescription,
    required this.productName,
    required this.productPrice,
    required this.productCode,
    required this.productImage,
    required this.reviews,
    this.isFeatured = false,
    this.isOrganic = false,
    this.imageUrl,
  });
  factory ProductModel.fromEntity(AddProductsEntity addProductEntity) {
    return ProductModel(
      reviews: addProductEntity.reviews
          .map((e) => ReviewsModel.fromEntity(e))
          .toList(),
      productName: addProductEntity.productName,
      productPrice: addProductEntity.productPrice,
      productCode: addProductEntity.productCode,
      productDescription: addProductEntity.productDescription,
      productImage: addProductEntity.productImage,
      isFeatured: addProductEntity.isFeatured,
      imageUrl: addProductEntity.imageUrl,
      expiryDateMonths: addProductEntity.expiryDateMonths,
      calorieDensity: addProductEntity.calorieDensity,
      caloriesReferenceWeight: addProductEntity.caloriesReferenceWeight,
      productRating: addProductEntity.productRating,
      ratingCount: addProductEntity.ratingCount,
      isOrganic: addProductEntity.isOrganic,
    );
  }
  toJson() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productCode': productCode,
      'productDescription': productDescription,
      'isFeatured': isFeatured,
      'imageUrl': imageUrl,
      'expiryDateMonths': expiryDateMonths,
      'calories': calorieDensity,
      'caloriesPerServing': caloriesReferenceWeight,
      'productRating': productRating,
      'ratingCount': ratingCount,
      'isOrganic': isOrganic,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}