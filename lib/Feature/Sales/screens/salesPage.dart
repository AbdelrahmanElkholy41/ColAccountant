import 'package:cal/Feature/Sales/modal/salesModal.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Add_Product/widget/CustomTextField.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  double extraProfit = 0;

  Future<List<SaleModel>> fetchSales() async {
    final data = await Supabase.instance.client
        .from('Sales')
        .select('*, Product(*)')
        .order('created_at', ascending: false);

    return (data as List).map((item) => SaleModel.fromMap(item)).toList();
  }

  void _showAddProfitBottomSheet() {
    double? enteredProfit;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "أدخل ربح إضافي يدويًا",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                title: 'قيمة الربح',
            
                onChange: (value) {
                  enteredProfit = double.tryParse(value);
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (enteredProfit != null && enteredProfit! > 0) {
                    setState(() {
                      extraProfit += enteredProfit!;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("تم إضافة ${enteredProfit!.toStringAsFixed(2)} جنيه للربح"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("الرجاء إدخال قيمة صحيحة"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text("إضافة"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text("Sales record")),
        actions: [
          IconButton(
            onPressed: _showAddProfitBottomSheet,
            icon: const Icon(Icons.add_chart),
            tooltip: 'إضافة ربح يدوي',
          ),
        ],
      ),
      body: FutureBuilder<List<SaleModel>>(
        future: fetchSales(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          final sales = snapshot.data!;
          if (sales.isEmpty) {
            return const Center(child: Text('لا توجد مبيعات حتى الآن'));
          }

          final totalProfit = sales.fold<double>(
            0.0,
                (sum, item) => sum + item.profit * item.quantity,
          ) +
              extraProfit;

          final totalSales = sales.fold<double>(
            0.0,
                (sum, item) => sum + item.totalPrice * item.quantity,
          );

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📦 إجمالي المبيعات: ${totalSales.toStringAsFixed(2)} جنيه',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '💰 إجمالي الأرباح: ${totalProfit.toStringAsFixed(2)} جنيه',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          'بيع ${sale.quantity}${sale.product.name} قطعة',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'سعر القطعة: ${sale.totalPrice.toStringAsFixed(2)} جنيه',
                            ),
                            Text(
                              'الإجمالي: ${(sale.totalPrice * sale.quantity).toStringAsFixed(2)} جنيه',
                            ),
                            Text(
                              'الربح: ${(sale.profit * sale.quantity).toStringAsFixed(2)} جنيه',
                            ),
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
