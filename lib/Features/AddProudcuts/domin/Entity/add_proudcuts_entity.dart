// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/reviews_entity.dart';

class AddProductsEntity {
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
  final List<ReviewsEntity> reviews;
  AddProductsEntity({
    required this.productName,
    required this.productPrice,
    required this.productCode,
    required this.productDescription,
    required this.productImage,
    this.isFeatured = false,
    this.imageUrl,
    required this.expiryDateMonths,
    required this.calorieDensity,
    required this.caloriesReferenceWeight,
    this.productRating = 0,
    this.ratingCount = 0,
    this.isOrganic = false,
    required this.reviews,
  });
}
