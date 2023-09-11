import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  final Function()? onPressed;
  const Comment({
    super.key,
    required this.text,
    required this.user,
    required this.time,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              onPressed?.call();
            },
            backgroundColor: Color(0xFF211B25),
            icon: Icons.delete_outline,
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF83015),
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //comment
                Row(
                  children: [
                    Text(
                      user,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(time),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  text,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
