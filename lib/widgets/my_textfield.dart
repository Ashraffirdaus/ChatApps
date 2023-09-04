import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String textFieldText;
  final TextEditingController controller;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.textFieldText,
      required this.controller,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(8.0)
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: textFieldText,
            ),
          ),
        ),
      ),
    );
  }
}
