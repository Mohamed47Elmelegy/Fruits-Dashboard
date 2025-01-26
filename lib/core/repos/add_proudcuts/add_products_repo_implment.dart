import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/Data/model/product_model.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/proudcuts_entity.dart';

import '../../errors/failure.dart';
import '../../services/database_service.dart';
import '../../utils/backend_endpoints.dart';
import 'add_products_repo.dart';

class AddProductRepoImplment implements AddProductsRepo {
  final DatabaseService databaseService;
  AddProductRepoImplment(this.databaseService);
  @override
  Future<Either<Failure, void>> addPrducts(
      ProductsEntity productsEntity) async {
    try {
      await databaseService.addData(
          path: Backendpoint.addProduct,
          data: ProductModel.fromEntity(productsEntity).toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add product'));
    }
  }
}
