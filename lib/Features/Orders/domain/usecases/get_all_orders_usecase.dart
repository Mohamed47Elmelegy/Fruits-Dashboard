import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entity/order_entity.dart';
import '../repositories/order_repository.dart';

class GetAllOrdersUseCase {
  final OrderRepository _repository;

  GetAllOrdersUseCase(this._repository);

  Future<Either<Failure, List<OrderEntity>>> call() async {
    return await _repository.getAllOrders();
  }
}
