import 'package:flutter/material.dart';

class TextFieldModel extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  TextFieldModel({
    required this.controller,
    required this.hintText,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
