import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onTap;
  const MyTextBox({
    super.key,
    required this.text,
    required this.sectionName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 50,
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 5,
      // ),
      decoration: BoxDecoration(
        color: Color(0xFFFFBFB0),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(sectionName),
              SizedBox(
                width: 20,
              ),
              Text(text),
            ],
          ),
          GestureDetector(onTap: onTap, child: Icon(Icons.settings))
        ],
      ),
    );
  }
}
