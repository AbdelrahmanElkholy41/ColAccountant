// Feature/Homepage/widght/homePageBody.dart
import 'package:cal/Feature/Add_Product/AddProductPage.dart';
import 'package:cal/Feature/Sales/screens/salesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../edit_Product/Logic/ProductCubit.dart';
import '../../edit_Product/Logic/ProductState.dart';
import 'customCard.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

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
              SizedBox(
                height: 65,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: const Text(
                            "Sales",
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SalesPage(),
                              ),
                            );
                          },
                        ),
                        const Text(
                          "Accountant",
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                        const Text(
                          "Accountant",
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      child: CustomCard(productModel: products[index]),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is ProductError) {
          return Center(child: Text('❌ ${state.message}'));
        } else {
          // return const Center(child: Text('Do not have any product please can add product'));
          return Center(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddProductPage()),
                );
              },
              child: Text(
                'Do not have any product please click her to  add product',
              ),
            ),
          );
        }
      },
    );
  }
}
