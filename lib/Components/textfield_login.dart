import 'package:flutter/material.dart';

class textfield_login extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;
  const textfield_login({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Colors.grey),
        filled: true,
        fillColor: Color(0xFFFFE2DC),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color:
                Color(0xFFF83015), // Set the color for the focused border line
            width: 2, // Set the thickness for the focused border line
          ),
        ),
      ),
    );
  }
}
