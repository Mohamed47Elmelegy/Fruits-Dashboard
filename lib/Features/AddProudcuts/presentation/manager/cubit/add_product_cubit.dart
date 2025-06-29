import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:furute_app_dashbord/core/repos/add_images/add_images_repo.dart';
import 'package:furute_app_dashbord/core/repos/add_proudcuts/add_products_repo.dart';

import '../../../domin/Entity/proudcuts_entity.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this.addImagesRepo, this.addProductsRepo)
      : super(AddProductInitial());

  final AddImagesRepo addImagesRepo;
  final AddProductsRepo addProductsRepo;

  Future<void> addProduct(ProductsEntity addProductsEntity) async {
    emit(AddProductLoding());
    var result =
        await addImagesRepo.uploadImage(File(addProductsEntity.imageUrl!));
    result.fold(
      (f) {
        emit(
          AddProductFailure(f.message),
        );
      },
      (url) async {
        final updatedProduct = ProductsEntity(
          productName: addProductsEntity.productName,
          productPrice: addProductsEntity.productPrice,
          productCode: addProductsEntity.productCode,
          productDescription: addProductsEntity.productDescription,
          isFeatured: addProductsEntity.isFeatured,
          imageUrl: url,
          expiryDateMonths: addProductsEntity.expiryDateMonths,
          calorieDensity: addProductsEntity.calorieDensity,
          unitAmount: addProductsEntity.unitAmount,
          productRating: addProductsEntity.productRating,
          ratingCount: addProductsEntity.ratingCount,
          isOrganic: addProductsEntity.isOrganic,
          reviews: addProductsEntity.reviews,
        );
        var result = await addProductsRepo.addPrducts(updatedProduct);
        result.fold(
          (f) {
            emit(
              AddProductFailure(f.message),
            );
          },
          (r) {
            emit(AddProductSuccess());
          },
        );
      },
    );
  }
}
