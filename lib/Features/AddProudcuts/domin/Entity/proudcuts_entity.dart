// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'dart:io';

import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/reviews_entity.dart';

class ProductsEntity extends Equatable {
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
  final List<ReviewsEntity> reviews;

  ProductsEntity({
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
  });

  @override
  List<Object?> get props => [productCode];

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'productCode': productCode,
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
