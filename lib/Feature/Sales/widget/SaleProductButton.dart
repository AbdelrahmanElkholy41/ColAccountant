// Feature/Sales/widget/SaleProductButton.dart
import 'package:cal/Feature/Sales/Logic/cubit/sales_cubit.dart';
import 'package:cal/Feature/edit_Product/Modal/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaleProductButton extends StatefulWidget {
  final ProductModel productModel;
  final Function(int)? onSaleSuccess;

  const SaleProductButton({
    super.key,
    required this.productModel,
    this.onSaleSuccess,
  });

  @override
  State<SaleProductButton> createState() => _SaleProductButtonState();
}

class _SaleProductButtonState extends State<SaleProductButton> {
  bool _isLoading = false;

  Future<void> _handleSale() async {
    int localQuantity = 1;

    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("أدخل الكمية المراد بيعها"),
              const SizedBox(height: 12),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "الكمية",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  localQuantity = int.tryParse(value) ?? 1;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(localQuantity);
                },
                child: const Text("تأكيد"),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (result != null && result > 0) {
      if (result > widget.productModel.count) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("لا يمكن بيع $result - الكمية المتاحة: ${widget.productModel.count}"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        await context.read<SalesCubit>().recordSale(
          product: widget.productModel,
          quantity: result,
        );

        if (widget.onSaleSuccess != null) {
          widget.onSaleSuccess!(result);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم بيع $result من المنتج بنجاح"),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("حدث خطأ أثناء البيع: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
        debugPrint("تفاصيل الخطأ: $e");
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else if (result != null && result <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("الكمية يجب أن تكون أكبر من الصفر"),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSale,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text(
              'بيع المنتج',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
    );
  }
}