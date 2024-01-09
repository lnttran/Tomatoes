import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/chatPage/chatLog.dart';
import 'package:tomatoes/homePage/addPost.dart';
import 'package:tomatoes/homePage/userPostCard.dart';

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
                      child: const Icon(
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
                      child: const Icon(
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
                      .collectionGroup('User Posts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final posts = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final currentPost = posts[index];
                          final userSnapshot =
                              currentPost.reference.parent.parent;

                          Future<Map<String, dynamic>?> fetchUserData(
                              DocumentReference<Map<String, dynamic>>?
                                  userSnapshot) async {
                            try {
                              if (userSnapshot != null) {
                                DocumentSnapshot<Map<String, dynamic>>
                                    snapshot = await userSnapshot.get();

                                if (snapshot.exists) {
                                  Map<String, dynamic>? userData =
                                      snapshot.data();
                                  return userData;
                                } else {
                                  print('Document does not exist.');
                                }
                              }
                            } catch (error) {
                              print('Error getting document: $error');
                            }
                            return null;
                          }

                          return FutureBuilder(
                              future: fetchUserData(userSnapshot),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final userData = snapshot.data!;
                                  return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: userPostCard(
                                          recipe: Recipe.fromJsonPost(
                                              currentPost.data()),
                                          postID: currentPost.id,
                                          userEmail: userData['Email']));
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                        'Error: ' + snapshot.error.toString()),
                                  );
                                }
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
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
