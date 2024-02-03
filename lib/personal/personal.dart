import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatoes/Components/edit_button.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/Components/userClass.dart';
import 'package:tomatoes/chatPage/chatPage.dart';
import 'package:tomatoes/homePage/addPost.dart';
import 'package:tomatoes/homePage/userPostCard.dart';
import 'package:tomatoes/method/APIs.dart';
import 'package:tomatoes/personal/edit_profile.dart';
import 'package:tomatoes/personal/personal_drawer.dart';

import '../main.dart';

class Personal_Page extends StatefulWidget {
  final String userUid;
  final bool isLeading;
  const Personal_Page(
      {super.key, required this.userUid, required this.isLeading});

  @override
  State<Personal_Page> createState() => _Personal_PageState();
}

class _Personal_PageState extends State<Personal_Page> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  bool isCurrentUserFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.isLeading,
        surfaceTintColor: Colors.white,
        actionsIconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      endDrawer: (currentUser.uid == widget.userUid) ? const MyDrawer() : null,
      body: StreamBuilder<DocumentSnapshot>(
        stream: userCollection.doc(widget.userUid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            List<dynamic> followingList =
                userData['Followings'] as List<dynamic>;
            List<dynamic> followerList = userData['Followers'] as List<dynamic>;
            isCurrentUserFollowing = followerList.contains(currentUser.uid);

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  bottom: widget.isLeading ? 0 : 15,
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
                                .doc(widget.userUid)
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
                          Text('${followerList.length}'),
                          Text(followerList.isEmpty ? 'Follower' : 'Followers'),
                        ]),
                        Column(children: [
                          Text('${followingList.length}'),
                          Text(followingList.isEmpty
                              ? 'Following'
                              : 'Followings'),
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
                          userData['Email'],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (widget.userUid == currentUser.uid)
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
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          edit_button(
                              onTap: () async {
                                setState(() {
                                  isCurrentUserFollowing =
                                      !isCurrentUserFollowing;
                                });
                                if (isCurrentUserFollowing) {
                                  await APIs.addCurrentUserFollowing(
                                      widget.userUid);

                                  followerList.add(currentUser.uid);
                                } else {
                                  await APIs.removeCurrentUserFollowing(
                                      widget.userUid);

                                  followerList.remove(currentUser.uid);
                                }

                                await userCollection
                                    .doc(widget.userUid)
                                    .update({'Followers': followerList});
                              },
                              text: isCurrentUserFollowing
                                  ? 'Following'
                                  : 'Follow'),
                          edit_button(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => chatPage(
                                          user: userClass.fromJson(userData)),
                                    ));
                              },
                              text: 'Message')
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
                            .doc(widget.userUid)
                            .collection('User Posts')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final currentUserPosts = snapshot.data!.docs;

                            if (currentUserPosts.isEmpty) {
                              // Return a message or placeholder when there are no user posts
                              return const Center(
                                child: Text("No recipe!"),
                              );
                            }

                            return ListView.builder(
                              itemCount: currentUserPosts.length,
                              itemBuilder: (context, index) {
                                final currentPost = currentUserPosts[index];
                                // final userUid = currentUser.uid;
                                //Desplay the userPost if that post is made by the user
                                return userPostCard(
                                    recipe:
                                        Recipe.fromJsonPost(currentPost.data()),
                                    postID: currentPost.id,
                                    userUid: widget.userUid);
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
