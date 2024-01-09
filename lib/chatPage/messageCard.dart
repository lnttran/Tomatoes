import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/chatPage/messageClass.dart';
import 'package:tomatoes/method/APIs.dart';
import 'package:tomatoes/method/convertTime.dart';

class messageCard extends StatefulWidget {
  final messageClass message;
  const messageCard({
    super.key,
    required this.message,
  });

  @override
  State<messageCard> createState() => _messageCardState();
}

class _messageCardState extends State<messageCard> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    //display (userMessage) the text if the current user's ID is equal to the message's fromID,
    // sender message if otherwise
    return currentUser.uid == widget.message.fromID
        ? _userMessage()
        : _senderMessage();
  }

  Widget _senderMessage() {
    //Update the last read message
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      //crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 15,
            ),
            margin: const EdgeInsets.only(
              // left: 15,
              // right: 15,
              bottom: 10,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFFFE2DC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Text(
            MyDateUtil.formatTimeFromEpoch(
                context: context, time: widget.message.sent),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _userMessage() {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: Text(
            MyDateUtil.formatTimeFromEpoch(
                context: context, time: widget.message.sent),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 15,
            ),
            margin: EdgeInsets.only(
              // left: 15,
              // right: 15,
              bottom: 10,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF83015),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                bottomLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
