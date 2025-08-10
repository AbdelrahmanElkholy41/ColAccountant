// Feature/Homepage/MyHomePage.dart
import 'package:cal/Feature/Homepage/widght/homePageBody.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.isAdmin});

  final bool isAdmin;  // خزن القيمة هنا

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(child: Text('All Product')),
      ),
      body: HomePageBody(isAdmin: isAdmin),  // مرر القيمة هنا
    );
  }
}
