import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/order_repository.dart';

class GetOrderStatisticsUseCase {
  final OrderRepository _repository;

  GetOrderStatisticsUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    return await _repository.getOrderStatistics();
  }
}
