import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/add_proudcuts_entity.dart';
import 'package:furute_app_dashbord/core/repos/add_proudcuts/add_product_repo.dart';

import '../../../../../core/repos/add_images/add_images_repo.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this.addProductsRepo, this.addImagesRepo)
      : super(AddProductInitial());
  final AddProductsRepo addProductsRepo;
  final AddImagesRepo addImagesRepo;
}
