import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/chatPage/chatPage.dart';
import 'package:tomatoes/chatPage/messageClass.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/Components/userClass.dart';
import 'package:tomatoes/method/APIs.dart';
import 'package:tomatoes/method/convertTime.dart';

class chatCard extends StatefulWidget {
  final userClass user;
  chatCard({
    super.key,
    required this.user,
  });

  @override
  State<chatCard> createState() => _chatCardState();
}

class _chatCardState extends State<chatCard> {
  //last message info (if null --> no message)
  messageClass? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 0,
      //inkwell is child widget response to touch gesture such as tap and ink effect
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => chatPage(user: widget.user),
                ));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => messageClass.fromJson(e.data())).toList() ??
                      [];
              [];

              if (list.isNotEmpty) _message = list[0];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(thisSize.height * .3),
                  child: CachedNetworkImage(
                    width: thisSize.height * .055,
                    height: thisSize.height * .055,
                    imageUrl: widget.user.image,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: thisSize.height * .055,
                      height: thisSize.height * .055,
                      decoration: const BoxDecoration(
                        //shape: BoxShape.circle,
                        color: Color(0xFFF83015),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                title: Text(
                  widget.user.username,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                    _message != null
                        ? _message!.type == Type.image
                            ? 'image'
                            : _message!.msg
                        : widget.user.email,
                    maxLines: 1),
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.fromID != APIs.currentUser!.uid
                        ? Container(
                            width: 13,
                            height: 13,
                            decoration: BoxDecoration(
                                color: const Color(0xFFF83015),
                                borderRadius: BorderRadius.circular(10)),
                          )
                        : Text(MyDateUtil.getLastMessageTime(
                            context: context, time: _message!.sent)),
              );
            },
          )),
    );
  }
}
