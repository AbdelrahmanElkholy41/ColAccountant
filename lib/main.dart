import 'package:cal/Feature/Sales/Logic/cubit/sales_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // ✅ استورد الباكيج

import 'Feature/Homepage/MyHomePage.dart';
import 'Feature/edit_Product/Logic/ProductCubit.dart';
import 'Feature/login/ui/login_screen.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ekaglytoelbqxoxreohk.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVrYWdseXRvZWxicXhveHJlb2hrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA0MjczNTksImV4cCI6MjA2NjAwMzM1OX0.EBkQk7Ojjm7Vberwo6NnY7LO3uiHthTexYW9mnayh5Y',
  );
  print('Supabase initialized successfully');
  await Supabase.instance.client.from("Product").select('*').limit(1);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductCubit()),
        BlocProvider(create: (context) => SalesCubit()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(1500, 800), // ✅ غيّر الأبعاد لو تصميمك مختلف
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: Routes.loginScreen,
            onGenerateRoute: AppRouter().generateRoute,


          );
        },
      ),
    );
  }
}

