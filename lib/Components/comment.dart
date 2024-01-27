import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/main.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Comment extends StatefulWidget {
  final String text;
  final String userUid;
  final String time;
  final Function()? onPressed;
  const Comment({
    super.key,
    required this.text,
    required this.userUid,
    required this.time,
    required this.onPressed,
  });

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.userUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return Slidable(
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      widget.onPressed?.call();
                    },
                    backgroundColor: const Color(0xFF211B25),
                    icon: Icons.delete_outline,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  right: 10,
                  left: 10,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(thisSize.height * .3),
                      child: CachedNetworkImage(
                        width: thisSize.height * .05,
                        height: thisSize.height * .05,
                        imageUrl: userData['Image'],
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: thisSize.height * .05,
                          height: thisSize.height * .05,
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
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //comment
                        Row(
                          children: [
                            Text(
                              userData['Username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(widget.time),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          widget.text,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
