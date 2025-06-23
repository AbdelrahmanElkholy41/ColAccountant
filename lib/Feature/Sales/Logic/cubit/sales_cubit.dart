// Feature/Sales/Logic/cubit/sales_cubit.dart
import 'package:cal/Feature/Sales/modal/salesModal.dart';
import 'package:cal/Feature/edit_Product/Modal/ProductModel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'sales_state.dart';


class SalesCubit extends Cubit<SalesState> {
  SalesCubit() : super(SalesInitial());

  final client = Supabase.instance.client;

  Future<void> fetchSales() async {
    emit(SalesLoading());
    try {
      final response = await client
          .from('Sales')
          .select()
          .order('created_at', ascending: false);

      final sales = (response as List)
          .map((e) => SaleModel.fromMap(e))
          .toList();

      emit(SalesLoaded(sales));
    } catch (e) {
      emit(SalesError('فشل في تحميل المبيعات: $e'));
    }
  }

  Future<void> recordSale({
    required ProductModel product,
    required int quantity,
  }) async {
    try {
      final total = product.price * quantity;
      final profit = (product.price - product.cost) * quantity;

      await client.from('Sales').insert({
        'product_id': product.id,
        'quantity': quantity,
        'total_price': total,
        'profit': profit,
      });

      await fetchSales(); // تحديث بعد الإضافة
    } catch (e) {
      emit(SalesError('فشل في تسجيل عملية البيع: $e'));
    }
  }
}
