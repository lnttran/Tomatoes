import 'package:flutter/material.dart';

class label_texfield extends StatelessWidget {
  final controller;
  final String labelText;

  const label_texfield({
    super.key,
    required this.controller,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintStyle: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Colors.grey),
        filled: false,
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
