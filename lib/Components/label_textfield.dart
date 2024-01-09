import 'package:flutter/material.dart';

class label_texfield extends StatelessWidget {
  final controller;
  final GlobalKey<FormState> formkey;
  final String labelText;
  final int maxlines;
  final int maxlength;
  final bool isNumber;

  label_texfield({
    super.key,
    required this.controller,
    required this.formkey,
    required this.labelText,
    required this.maxlines,
    required this.maxlength,
    required this.isNumber,
  });

  // @override
  // Widget build(BuildContext context) {
  //   return TextField(
  //     controller: controller,
  //     cursorOpacityAnimates: true,
  //     maxLines: maxlines,
  //     maxLength: maxlength,
  //     cursorColor: Colors.black38,
  //     textAlignVertical: TextAlignVertical.center,
  //     cursorWidth: 1,
  //     decoration: InputDecoration(
  //       counterText: '',
  //       hintText: labelText,
  //       hintStyle: Theme.of(context)
  //           .textTheme
  //           .headlineSmall
  //           ?.copyWith(color: Colors.grey),
  //       filled: false,
  //       contentPadding:
  //           const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
  //       enabledBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(15),
  //         borderSide: const BorderSide(
  //           color: Colors.white,
  //           width: 1,
  //         ),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(15),
  //         borderSide: const BorderSide(
  //           color: Color.fromARGB(
  //               189, 44, 44, 44), // Set the color for the focused border line
  //           width: 1, // Set the thickness for the focused border line
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey, // Declare a GlobalKey<FormState> variable
      child: TextFormField(
        controller: controller,
        cursorOpacityAnimates: true,
        maxLines: maxlines,
        maxLength: maxlength,
        cursorColor: Colors.black38,
        cursorHeight: 20,
        textAlignVertical: TextAlignVertical.center,
        cursorWidth: 1,
        style: Theme.of(context).textTheme.headlineSmall,
        decoration: InputDecoration(
          counterText: '',
          hintText: labelText,
          hintStyle: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFFFE2DC), // Set background color
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(
                  0xFFF83015), // Set the color for the focused border line
              width: 1, // Set the thickness for the focused border line
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color(
                  0xFFF83015), // Set the color for the focused border line
              width: 1, // Set the thickness for the focused border line
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Color.fromARGB(187, 108, 108, 108),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.black, // Set the color for the focused border line
              width: 1, // Set the thickness for the focused border line
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required.';
          }

          if (isNumber && !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Please enter a number.';
          }
          return null; // Return null if the input is valid
        },
      ),
    );
  }
}
