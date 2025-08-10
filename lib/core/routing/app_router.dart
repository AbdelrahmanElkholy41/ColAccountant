// core/routing/app_router.dart
import 'package:cal/Feature/Add_Product/AddProductPage.dart';
import 'package:cal/Feature/Homepage/MyHomePage.dart';
import 'package:cal/Feature/Sales/screens/salesPage.dart';
import 'package:cal/Feature/dashboard/ui/dashboard_screen.dart';
import 'package:cal/Feature/edit_Product/Logic/ProductCubit.dart';
import 'package:cal/Feature/login/Logic/cubit/cubit/login_cubit.dart';
import 'package:cal/Feature/login/ui/login_screen.dart';
import 'package:cal/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.salesScreen:
        return MaterialPageRoute(builder: (_) => const SalesPage());

      case Routes.addProductScreen:
        return MaterialPageRoute(builder: (_) => const AddProductPage());

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(),
            child: LoginScreen(
              isAdmin: args is bool ? args : false, // لو حبيت تمرر هنا
            ),
          ),
        );

      case Routes.dashboardScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProductCubit(),
            child: DashboardScreen(
              isAdmin: args is bool ? args : true, // خذ القيمة لو موجودة
            ),
          ),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => MyHomePage(
            isAdmin: args is Map && args['isAdmin'] != null
                ? args['isAdmin'] as bool
                : false, // هنا لازم تتأكد من القيمة
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
