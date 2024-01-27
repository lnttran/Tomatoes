import 'package:flutter/material.dart';
import 'package:tomatoes/main.dart';

class edit_button extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const edit_button({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: thisSize.width * .45,
        height: thisSize.width * .07,
        // margin: const EdgeInsets.symmetric(
        //   horizontal: 5,
        // ),
        decoration: BoxDecoration(
          color: const Color(0xFFF83015),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
