import 'package:cal/Feature/Sales/screens/salesPage.dart';
import 'package:cal/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Feature/Homepage/MyHomePage.dart';
import '../../Feature/login/ui/login_screen.dart';
class AppRouter {
  Route generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.salesScreen:
        return MaterialPageRoute(
          builder: (_) => const SalesPage(),
        );
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const MyHomePage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
