import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomatoes/chatPage/chatLog.dart';
import 'package:tomatoes/homePage/addPost.dart';
import 'package:tomatoes/homePage/userPost.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  // final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              //title
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => chatLog())));
                      },
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'My Feed',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addPost(),
                            ));
                      },
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              //the wall

              Expanded(
                //takes the stream and builder function as an argument.
                //automatically rebuild the widget tree whenver new data is avaible for chnage
                child: StreamBuilder(
                  /**
                   * stream is the property that can be provided the stream of the data 
                   * in ths case is the Firestore quey that retrieves data frm the 'User Posts' collection
                   */
                  stream: FirebaseFirestore.instance
                      .collection('User Posts')
                      .orderBy(
                        'TimeStamp',
                        descending: false,
                      )
                      //this moethod converts the Firestor query into stram of snapshots.
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final post = snapshot.data!.docs[index];
                          return userPost(
                            recipe: post['Recipe'],
                            user: post['Email'],
                            postID: post.id,
                            likes: List<String>.from(post['Likes'] ?? []),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ' + snapshot.error.toString()),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              //post message
            ],
          ),
        ),
      ),
    );
  }
}
