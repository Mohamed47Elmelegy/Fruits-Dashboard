import 'package:furute_app_dashbord/Features/AddProudcuts/domin/Entity/add_proudcuts_entity.dart';

abstract class AddProductsRepo {
  Future<void> addPrducts(AddProductsEntity addProductsEntity);
}
