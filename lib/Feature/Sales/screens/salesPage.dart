// Feature/Sales/screens/salesPage.dart
import 'package:cal/Feature/Sales/modal/salesModal.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  Future<List<SaleModel>> fetchSales() async {
    final data = await Supabase.instance.client
        .from('Sales')
        .select()
        .order('created_at', ascending: false);

    return (data as List).map((item) => SaleModel.fromMap(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('سجل المبيعات')),
      body: FutureBuilder<List<SaleModel>>(
        future: fetchSales(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sales = snapshot.data!;
          if (sales.isEmpty) {
            return const Center(child: Text('لا توجد مبيعات حتى الآن'));
          }

          // حساب الإجماليات
          final totalProfit = sales.fold<double>(0.0, (sum, item) => sum + item.profit);
          final totalSales = sales.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📦 إجمالي المبيعات: ${totalSales.toStringAsFixed(2)} جنيه',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '💰 إجمالي الأرباح: ${totalProfit.toStringAsFixed(2)} جنيه',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1),
              Expanded(
                child: ListView.separated(
                  itemCount: sales.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final sale = sales[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(
                          'بيع ${sale.quantity} قطعة',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('الإجمالي: ${sale.totalPrice.toStringAsFixed(2)} جنيه'),
                            Text('الربح: ${sale.profit.toStringAsFixed(2)} جنيه'),
                          ],
                        ),
                        trailing: Text(
                          '${sale.createdAt.day}/${sale.createdAt.month} - ${sale.createdAt.hour}:${sale.createdAt.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
