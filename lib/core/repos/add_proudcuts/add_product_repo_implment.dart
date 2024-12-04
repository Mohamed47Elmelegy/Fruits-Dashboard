import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/Data/model/add_product_model.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/add_proudcuts_entity.dart';
import 'package:furute_app_dashbord/core/repos/add_proudcuts/add_product_repo.dart';

import '../../errors/failure.dart';
import '../../services/database_service.dart';
import '../../utils/backend_endpoints.dart';

class AddProductRepoImplment implements AddProductsRepo {
  final DatabaseService databaseService;
  AddProductRepoImplment(this.databaseService);
  @override
  Future<Either<Failure, void>> addPrducts(
      AddProductsEntity addProductsEntity) async {
    try {
      await databaseService.addData(
          path: Backendpoint.addProduct,
          data: ProductModel.fromEntity(addProductsEntity).toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add product'));
    }
  }
}
