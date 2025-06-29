import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entity/order_entity.dart';
import '../repositories/order_repository.dart';

class SearchOrdersUseCase {
  final OrderRepository _repository;

  SearchOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> call(String query) async {
    return await _repository.searchOrders(query);
  }
}
