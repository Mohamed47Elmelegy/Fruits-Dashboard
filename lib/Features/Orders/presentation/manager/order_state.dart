part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderUpdating extends OrderState {}

class OrderLoaded extends OrderState {
  final List<OrderEntity> orders;

  const OrderLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderFailure extends OrderState {
  final String message;

  const OrderFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderStatisticsLoading extends OrderState {}

class OrderStatisticsLoaded extends OrderState {
  final Map<String, dynamic> statistics;

  const OrderStatisticsLoaded(this.statistics);

  @override
  List<Object?> get props => [statistics];
}

class OrderStatisticsFailure extends OrderState {
  final String message;

  const OrderStatisticsFailure(this.message);

  @override
  List<Object?> get props => [message];
}
