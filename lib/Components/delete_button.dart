import 'package:flutter/material.dart';

class delete_button extends StatelessWidget {
  final void Function()? onTap;
  const delete_button({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Icon(
          Icons.delete_outline,
          color: Colors.grey[600],
        ));
  }
}
