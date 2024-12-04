import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:furute_app_dashbord/core/repos/add_images/add_images_repo.dart';
import 'package:furute_app_dashbord/core/repos/add_proudcuts/add_product_repo.dart';

import '../../../domin/Entity/add_proudcuts_entity.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this.addImagesRepo, this.addProductsRepo)
      : super(AddProductInitial());

  final AddImagesRepo addImagesRepo;
  final AddProductsRepo addProductsRepo;

  Future<void> addProduct(AddProductsEntity addProductsEntity) async {
    emit(AddProductLoding());
    var result =
        await addImagesRepo.uploadImage(addProductsEntity.productImage);
    result.fold(
      (f) {
        emit(
          AddProductFailure(f.message),
        );
      },
      (url) async {
        addProductsEntity.imageUrl = url;
        var result = await addProductsRepo.addPrducts(addProductsEntity);
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
