part of 'add_product_cubit.dart';

sealed class AddProductState extends Equatable {
  const AddProductState();

  @override
  List<Object> get props => [];
}

final class AddProductInitial extends AddProductState {}

final class AddProductLoading extends AddProductState {}

final class AddProductSuccess extends AddProductState {
  final AddProductsEntity addProductsEntity;

  const AddProductSuccess(this.addProductsEntity);
}

final class AddProductFailure extends AddProductState {
  final String errMessage;

  const AddProductFailure(this.errMessage);
}
