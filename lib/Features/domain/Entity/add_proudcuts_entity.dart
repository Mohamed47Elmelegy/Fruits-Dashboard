import 'dart:io';

class AddProductsEntity {
  final String productName;
  final num productPrice;
  final String productCode;
  final String productDescription;
  final File productImage;
  final bool isFeatured;
  String? imgaeUrl;
  AddProductsEntity(
      {required this.productDescription,
      required this.productName,
      required this.productPrice,
      required this.productCode,
      required this.productImage,
      required this.isFeatured,
      this.imgaeUrl});
}
