import 'package:furute_app_dashbord/Features/AddProudcuts/Data/model/reviews_model.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';
import '../../functions/avg_rating.dart';

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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productName: json['productName'] ?? '',
      productPrice: json['productPrice'] ?? 0,
      productCode: json['productCode'] ?? '',
      productDescription: json['productDescription'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
      imageUrl: json['imageUrl'],
      expiryDateMonths: json['expiryDateMonths'] ?? 0,
      calorieDensity: json['calories'] ?? 0,
      unitAmount: json['unitAmount'] ?? 0,
      productRating: getAvgRating(json['reviews'] != null
          ? List<ReviewsModel>.from(
              json['reviews'].map((e) => ReviewsModel.fromJson(e)))
          : []),
      ratingCount: json['ratingCount'] ?? 0,
      isOrganic: json['isOrganic'] ?? false,
      reviews: json['reviews'] != null
          ? List<ReviewsModel>.from(
              (json['reviews'] as List).map((e) => ReviewsModel.fromJson(e)))
          : [],
      sellingCount: json['sellingCount'] ?? 0,
    );
  }

  factory ProductModel.fromEntity(ProductsEntity entity) {
    return ProductModel(
      productName: entity.productName,
      productPrice: entity.productPrice,
      productCode: entity.productCode,
      productDescription: entity.productDescription,
      isFeatured: entity.isFeatured,
      imageUrl: entity.imageUrl,
      expiryDateMonths: entity.expiryDateMonths,
      calorieDensity: entity.calorieDensity,
      unitAmount: entity.unitAmount,
      productRating: entity.productRating,
      ratingCount: entity.ratingCount,
      isOrganic: entity.isOrganic,
      reviews: entity.reviews.map((e) => ReviewsModel.fromEntity(e)).toList(),
      sellingCount: 0, // or any default value
    );
  }

  ProductsEntity toEntity() {
    return ProductsEntity(
      productName: productName,
      productPrice: productPrice,
      productCode: productCode,
      productDescription: productDescription,
      isFeatured: isFeatured,
      imageUrl: imageUrl,
      expiryDateMonths: expiryDateMonths,
      calorieDensity: calorieDensity,
      unitAmount: unitAmount,
      productRating: productRating,
      ratingCount: ratingCount,
      isOrganic: isOrganic,
      reviews: reviews.map((e) => e.toEntity()).toList(),
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
      'calorieDensity': calorieDensity,
      'unitAmount': unitAmount,
      'productRating': productRating,
      'ratingCount': ratingCount,
      'isOrganic': isOrganic,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          productCode == other.productCode;

  @override
  int get hashCode => productCode.hashCode;
}
