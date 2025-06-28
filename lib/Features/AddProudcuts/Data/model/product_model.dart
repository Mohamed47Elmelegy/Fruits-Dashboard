import 'dart:io';

import 'package:furute_app_dashbord/Features/AddProudcuts/Data/model/reviews_model.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';

class ProductModel {
  final String productName;
  final num productPrice;
  final String productCode;
  final String productDescription;
  final bool isFeatured;
  String? imageUrl;
  final int expiryDateMonths;
  final int calorieDensity;
  final int unitAmount;
  final num productRating;
  final num ratingCount;
  final bool isOrganic;
  final List<ReviewsModel> reviews;
  final num sellingCount;
  ProductModel({
    required this.productName,
    required this.productPrice,
    required this.productCode,
    required this.productDescription,
    this.isFeatured = false,
    this.imageUrl,
    required this.expiryDateMonths,
    required this.calorieDensity,
    required this.unitAmount,
    this.productRating = 0,
    this.ratingCount = 0,
    this.isOrganic = false,
    required this.reviews,
    this.sellingCount = 0,
  });
  factory ProductModel.fromEntity(ProductsEntity addProductEntity) {
    return ProductModel(
      reviews: addProductEntity.reviews
          .map((e) => ReviewsModel.fromEntity(e))
          .toList(),
      productName: addProductEntity.productName,
      productPrice: addProductEntity.productPrice,
      productCode: addProductEntity.productCode,
      productDescription: addProductEntity.productDescription,
      isFeatured: addProductEntity.isFeatured,
      imageUrl: addProductEntity.imageUrl,
      expiryDateMonths: addProductEntity.expiryDateMonths,
      calorieDensity: addProductEntity.calorieDensity,
      unitAmount: addProductEntity.unitAmount,
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
      'sellingCount': sellingCount,
      'productDescription': productDescription,
      'isFeatured': isFeatured,
      'imageUrl': imageUrl,
      'expiryDateMonths': expiryDateMonths,
      'calories': calorieDensity,
      'unitAmount': unitAmount,
      'productRating': productRating,
      'ratingCount': ratingCount,
      'isOrganic': isOrganic,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}
