import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/userClass.dart';
import 'package:tomatoes/chatPage/messageCard.dart';
import 'package:tomatoes/chatPage/messageClass.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/method/APIs.dart';
import 'package:tomatoes/method/convertTime.dart';

class chatPage extends StatefulWidget {
  final userClass user;
  chatPage({
    super.key,
    required this.user,
  });

  @override
  State<chatPage> createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  List<messageClass> _list = [];

  //handling message
  final textController = TextEditingController();

  // toogle on chosing emoji or not
  bool _showEmoji = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // _onBackspacePressed() {
  //   textController
  //     ..text = textController.text.characters.toString()
  //     ..selection = TextSelection.fromPosition(
  //         TextPosition(offset: textController.text.length));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Row(
            children: [
              ClipRRect(
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
                    decoration: BoxDecoration(
                      //shape: BoxShape.circle,
                      color: Color(0xFFF83015),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.firstName + " " + widget.user.lastName,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Last active at ' +
                          MyDateUtil.formatTimeFromEpoch(
                              context: context, time: widget.user.lastActive),
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // You can add other widgets here as well
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    //final is to declare a variable that can only be assigned a value once

                    switch (snapshot.connectionState) {
                      //if data is loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      // return const Center(
                      //   child: CircularProgressIndicator(),
                      // );

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => messageClass.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                // print(_list[
                                //     index]); // Add this line to print the content
                                return messageCard(
                                  message: _list[index],
                                );
                              });
                        } else {
                          return Center(
                              child: Text(
                            'Say hi!',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ));
                        }
                    }
                  },
                ),
              ),
              chatInput(),

              //show the emoji on keyboard when the emoji button is chosen
            ],
          ),
        ),
      ),
    );
  }

  Widget chatInput() {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 0,
            color: Color(0xFFFFE2DC),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  //emoji button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showEmoji = !_showEmoji;
                      });
                    },
                    child: Icon(Icons.emoji_emotions_outlined),
                  ),

                  //send  text message field
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Text message',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w200,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  //attach file button
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.attach_file_outlined),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  //send pictures and photo
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.photo_library_outlined),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        GestureDetector(
            onTap: () {
              if (textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, textController.text, Type.text);
                textController.clear(); // Clear the text input
              }
            },
            child: Icon(Icons.send, color: Color(0xFFF83015))),
      ],
    );
  }
}
