import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
   CustomTextField({
    super.key, required this.title, required this.onChange,
  });
 final void Function(String) onChange;
final  String title;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged:onChange ,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: title,
      ),
    );
  }
}
