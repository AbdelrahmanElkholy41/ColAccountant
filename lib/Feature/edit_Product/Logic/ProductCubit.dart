import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Modal/ProductModel.dart';
import 'ProductState.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  final SupabaseClient client = Supabase.instance.client;

  // دالة لفحص الاتصال بالسيرفر
  Future<bool> checkConnection() async {
    try {
      final response = await client.from('Product').select('*').limit(1);
      final isConnected = response.isNotEmpty;
      print('✅ اتصال Supabase: ${isConnected ? 'ناجح' : 'لا يوجد بيانات'}');
      return isConnected;
    } catch (e) {
      print('❌ فشل الاتصال: ${e.toString()}');
      emit(ProductError('فشل الاتصال بالسيرفر'));
      return false;
    }
  }

  Future<void> checkTable() async {
    try {
      final tables = await client.rpc('list_tables');
      print('✅ الجداول المتاحة: $tables');
    } catch (e) {
      print('❌ خطأ في جلب الجداول: $e');
      emit(ProductError('فشل في التحقق من الجداول'));
    }
  }

  Future<void> fetchProducts() async {
    emit(ProductLoading()); /**/

    try {
      // التحقق من الاتصال أولاً
      final isConnected = await checkConnection();
      if (!isConnected) return;

      final response = await client.from(/**/ "Product").select('*');

      final products =
          (response as List).map((item) => ProductModel.fromMap(item)).toList();

      emit(ProductSuccessfully(products));
    } catch (e) {
      emit(ProductError('فشل تحميل المنتجات: ${e.toString()}'));
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      final response = await client
          .from("Product") // بدون علامات تنصيص (إذا كان الجدول بأحرف صغيرة)
          .insert({
            'Name': product.name,
            'Count': product.count,
            'Price': product.price,
            'Image': product.imageUrl,
            'Description': product.description,
            'Cost': product.cost,
          })
          .select('*');

      if (response.isNotEmpty) {
        print('✅ تم الإدراج. ID: ${response.first['id']}');
        fetchProducts();
      } else {
        print('⚠️ تم الإرسال بدون استجابة');
      }
    } on PostgrestException catch (e) {
      print('🔥 خطأ Supabase: ${e.code} - ${e.message}');
      if (e.code == '404') {
        print('✳️ تأكد من:');
        print('1. اسم الجدول (Product)');
        print('2. سياسات RLS');
        print('3. أسماء الأعمدة');
      }
    } catch (e) {
      print('🐛 خطأ غير متوقع: ${e.toString()}');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      emit(ProductLoading());

      await client.from("Product").delete().eq('id', id);
      fetchProducts(); // تحديث القائمة بعد الحذف
    } catch (e) {
      emit(ProductError('فشل حذف المنتج: ${e.toString()}'));
    }
  }

  // دالة مساعدة لتحديث المنتج
  Future<void> updateProduct(ProductModel product) async {
    try {
      emit(ProductLoading());

      await client
          .from("Product")
          .update({
            'Name': product.name,
            'Count': product.count,
            'Price': product.price,
            'Image': product.imageUrl,
            'Description': product.description,
            'Cost': product.cost,
          })
          .eq('id', product.id);

      fetchProducts();
      print(product);
    } catch (e) {
      print('🔁 تحديث المنتج ID: ${product.id}');

      print(e.toString());
      emit(ProductError('فشل تحديث المنتج: ${e.toString()}'));
    }
  }
}
