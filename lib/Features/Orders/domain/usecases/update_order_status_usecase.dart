import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/order_repository.dart';

class UpdateOrderStatusUseCase {
  final OrderRepository _repository;

  UpdateOrderStatusUseCase(this._repository);

  Future<Either<Failure, void>> call(
    String orderId,
    String newStatus, {
    String? notes,
  }) async {
    return await _repository.updateOrderStatus(orderId, newStatus,
        notes: notes);
  }
}
