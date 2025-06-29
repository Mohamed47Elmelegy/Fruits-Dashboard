import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entity/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrdersByStatusUseCase {
  final OrderRepository _repository;

  GetOrdersByStatusUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> call(String status) async {
    return await _repository.getOrdersByStatus(status);
  }
}
