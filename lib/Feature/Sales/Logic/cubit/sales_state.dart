// Feature/Sales/Logic/cubit/sales_state.dart
import 'package:cal/Feature/Sales/modal/salesModal.dart';

abstract class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesLoaded extends SalesState {
  final List<SaleModel> sales;

  SalesLoaded(this.sales);
}

class SalesError extends SalesState {
  final String message;

  SalesError(this.message);
}
