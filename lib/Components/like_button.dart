import 'package:flutter/material.dart';

class like_button extends StatelessWidget {
  final bool isLiked;
  void Function()? onTap;
  like_button({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? const Color(0xFFF83015) : Colors.black),
    );
  }
}
