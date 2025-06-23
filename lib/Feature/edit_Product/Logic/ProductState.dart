import '../Modal/ProductModel.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductSuccessfully extends ProductState {
  final List<ProductModel> products;

  ProductSuccessfully(this.products);
}

class ProductError extends ProductState {
  final String message;

  ProductError(this.message);
}
