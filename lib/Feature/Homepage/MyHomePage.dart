// Feature/Homepage/MyHomePage.dart
import 'package:cal/Feature/Homepage/widght/homePageBody.dart';
import 'package:flutter/material.dart';

import '../Add_Product/AddProductPage.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddProductPage(),
            ), // ✅ استخدم const
          );
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(child: Text('All Product')),
      ),
      body: HomePageBody(),
    );
  }
}
