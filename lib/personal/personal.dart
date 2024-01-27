import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatoes/Components/edit_button.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/homePage/addPost.dart';
import 'package:tomatoes/homePage/userPostCard.dart';
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
        stream: userCollection.doc(currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            int followersLength = (userData['Followers'] as List?)?.length ?? 0;
            int followingsLength =
                (userData['Followings'] as List?)?.length ?? 0;

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .doc(currentUser.uid)
                                .collection('User Posts')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final posts = snapshot.data!.docs;
                                return Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text('${posts.length}'),
                                        Text(posts.isNotEmpty
                                            ? 'Posts'
                                            : 'Post'),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return const Column(children: [
                                Text('0'),
                                Text('Post'),
                              ]);
                            }),
                        Column(children: [
                          Text('$followersLength'),
                          Text(followersLength > 0 ? 'Followers' : 'Follower'),
                        ]),
                        Column(children: [
                          Text('$followingsLength'),
                          Text(followingsLength > 0
                              ? 'Followings'
                              : 'Following'),
                        ]),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          currentUser.email!,
                        )
                      ],
                    ),
                    const SizedBox(
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
                    const SizedBox(
                      height: 20,
                    ),
                    //need to add ordered by the time so that the post will display the lastest user post
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(currentUser.uid)
                            .collection('User Posts')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final currentUserPosts = snapshot.data!.docs;

                            if (currentUserPosts.isEmpty) {
                              // Return a message or placeholder when there are no user posts
                              return const Center(
                                child: Text("Upload your first recipe!"),
                              );
                            }

                            return ListView.builder(
                              itemCount: currentUserPosts.length,
                              itemBuilder: (context, index) {
                                final currentPost = currentUserPosts[index];
                                final userUid = currentUser.uid;
                                //Desplay the userPost if that post is made by the user
                                return userPostCard(
                                    recipe:
                                        Recipe.fromJsonPost(currentPost.data()),
                                    postID: currentPost.id,
                                    userUid: userUid);
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child:
                                  Text('Error: ' + snapshot.error.toString()),
                            );
                          }
                          return const SizedBox();
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
