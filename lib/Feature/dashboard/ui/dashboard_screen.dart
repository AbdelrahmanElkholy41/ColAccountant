// Feature/dashboard/ui/dashboard_screen.dart
import 'package:cal/core/helpers/extensions.dart';
import 'package:cal/core/helpers/spacing.dart';
import 'package:cal/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routing/routes.dart';
import '../../../core/theming/styles.dart';
import '../../edit_Product/Logic/ProductCubit.dart';
import '../../edit_Product/Logic/ProductState.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.isAdmin});
  final bool isAdmin ; // افتراضياً غير مسؤول

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().fetchProducts(); // ✅ هنا مكانه الصح
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.mainBlue,
        title: Center(
          child: Text('Dashboard', style: TextStyles.font24BlackBold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: ColorsManager.mainBlue),
              child: Text('dashboard', style: TextStyles.font18DarkBlueSemiBold),
            ),
            ListTile(
              leading: Icon(Icons.home, color: ColorsManager.darkBlue),
              title: Text('Home', style: TextStyles.font18DarkBlueSemiBold),
              onTap: () => context.pushNamed(Routes.homeScreen,arguments: {'isAdmin': widget.isAdmin}),
            ),
            ListTile(
              leading: Icon(Icons.point_of_sale_sharp, color: ColorsManager.darkBlue),
              title: Text('Sales', style: TextStyles.font18DarkBlueSemiBold),
              onTap: () => context.pushNamed(Routes.salesScreen),
            ),
            ListTile(
              leading: Icon(Icons.add, color: ColorsManager.darkBlue),
              title: Text('Add Product', style: TextStyles.font18DarkBlueSemiBold),
              onTap: () => context.pushNamed(Routes.addProductScreen),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: ColorsManager.darkBlue),
              title: Text('Logout', style: TextStyles.font18DarkBlueSemiBold),
              onTap: () {
              
                context.pushNamed(Routes.loginScreen);}
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 250.w,
              height: 250.h,
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductSuccessfully) {
                    return buildProductCard(state.products.length);
                  } else if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return buildProductCard(0);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductCard(int count) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.inventory, color: Colors.green),
            verticalSpace(12.h),
            Text('Total of Products', style: TextStyles.font18DarkBlueBold),
            verticalSpace(12.h),
            Text(
              '$count',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 22,

              ),
            ),
          ],
        ),
      ),
    );
  }
}

