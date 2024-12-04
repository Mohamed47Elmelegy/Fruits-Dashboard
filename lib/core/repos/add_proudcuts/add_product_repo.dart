import 'package:dartz/dartz.dart';
import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/add_proudcuts_entity.dart';

import '../../errors/failure.dart';

abstract class AddProductsRepo {
  Future<Either<Failure, void>> addPrducts(AddProductsEntity addProductsEntity);
}
