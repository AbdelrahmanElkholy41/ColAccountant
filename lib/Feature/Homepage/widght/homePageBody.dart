// Feature/Homepage/widght/homePageBody.dart
import 'package:cal/Feature/Add_Product/AddProductPage.dart';
import 'package:cal/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../edit_Product/Logic/ProductCubit.dart';
import '../../edit_Product/Logic/ProductState.dart';
import 'customCard.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key, required this.isAdmin});

  final bool isAdmin;

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blue),
          );
        } else if (state is ProductSuccessfully) {
          final products = state.products;

          return Column(
            children: [
              verticalSpace(30.h),
              Expanded(
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 800 ? 6 : 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CustomCard(
                        productModel: products[index],
                        isAdmin: widget.isAdmin, // هنا تمرير القيمة
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is ProductError) {
          return Center(child: Text('❌ ${state.message}'));
        } else {
          return Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
              },
              child: const Text(
                'Do not have any product please click her to add product',
              ),
            ),
          );
        }
      },
    );
  }
}
