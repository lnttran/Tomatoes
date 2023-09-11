import 'package:flutter/material.dart';

class comment_button extends StatelessWidget {
  final void Function()? onTap;
  const comment_button({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.comment_outlined,
        color: Colors.grey[600],
      ),
    );
  }
}
