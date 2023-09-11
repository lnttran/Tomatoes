import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatoes/Components/edit_button.dart';
import 'package:tomatoes/homePage/addPost.dart';
import 'package:tomatoes/homePage/userPost.dart';
import 'package:tomatoes/method/APIs.dart';
import 'package:tomatoes/personal/edit_profile.dart';
import 'package:tomatoes/personal/personal_drawer.dart';

import '../main.dart';

class Personal_Page extends StatefulWidget {
  const Personal_Page({super.key});

  @override
  State<Personal_Page> createState() => _Personal_PageState();
}

class _Personal_PageState extends State<Personal_Page> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        //automaticallyImplyLeading: true,
      ),
      endDrawer: const MyDrawer(),
      body: StreamBuilder<DocumentSnapshot>(
        //geting the information of Users->widget.user.email
        stream: userCollection.doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  bottom: 15,
                  right: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(thisSize.height * .3),
                          child: CachedNetworkImage(
                            width: thisSize.height * .075,
                            height: thisSize.height * .075,
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
                              width: thisSize.height * .075,
                              height: thisSize.height * .075,
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
                        SizedBox(
                          width: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Text('Post'),
                            ]),
                            Column(children: [
                              Text('Follower'),
                            ]),
                            Column(children: [
                              Text('Following'),
                            ]),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          currentUser.email!,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        edit_button(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => edit_profile(),
                                  ));
                            },
                            text: 'Edit profile'),
                        edit_button(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => addPost(),
                                  ));
                            },
                            text: 'Add recipe')
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('User Posts')
                            .orderBy(
                              'TimeStamp',
                              descending: false,
                            )
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final currentUserPosts = snapshot.data!.docs
                                .where((currentUserPosts) =>
                                    currentUserPosts['Email'] as String ==
                                    currentUser.email)
                                .toList();

                            if (currentUserPosts.isEmpty) {
                              // Return a message or placeholder when there are no user posts
                              return Center(
                                child: Text("Upload your first recipe!"),
                              );
                            }

                            return ListView.builder(
                              itemCount: currentUserPosts.length,
                              itemBuilder: (context, index) {
                                final post = currentUserPosts[index];
                                //Desplay the userPost if that post is made by the user
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
                              child:
                                  Text('Error: ' + snapshot.error.toString()),
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
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
        },
      ),
    );
  }
}
