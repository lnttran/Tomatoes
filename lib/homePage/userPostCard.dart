import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/comment.dart';
import 'package:tomatoes/Components/delete_button.dart';
import 'package:tomatoes/Components/like_button.dart';
import 'package:tomatoes/Components/comment_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/method/convertTime.dart';
import 'package:tomatoes/personal/personal.dart';
import 'package:tomatoes/recipe/recipeCard.dart';

// Display users' post information to the home page
class userPostCard extends StatefulWidget {
  final String postID;
  final Recipe recipe;
  final String userUid;

  const userPostCard({
    super.key,
    required this.recipe,
    required this.postID,
    required this.userUid,
  });

  @override
  State<userPostCard> createState() => _userPostCardState();
}

class _userPostCardState extends State<userPostCard> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  final userCollection = FirebaseFirestore.instance.collection('Users');
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.recipe.likes.contains(currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      //geting the information of Users->widget.user.email
      stream: userCollection.doc(widget.userUid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFE2DC),
              borderRadius: BorderRadius.circular(25),
            ),
            margin: const EdgeInsets.only(
              top: 15,
              left: 5,
              right: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Personal_Page(
                                      userUid: widget.userUid,
                                      isLeading: true)));
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(thisSize.height * .3),
                              child: CachedNetworkImage(
                                width: thisSize.height * .055,
                                height: thisSize.height * .055,
                                imageUrl: userData['Image'],
                                imageBuilder: (context, imageProvider) =>
                                    Container(
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
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              userData['Username'],
                              style: TextStyle(color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ),
                      if (userData['Uid'] == currentUser.uid)
                        delete_button(
                          onTap: deletePost,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                recipeCard(
                  recentlyView: false,
                  recipe: widget.recipe,
                  isFave: false,
                  onRecipeCardClicked: () {},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(
                    color: Color(0xFFFFBFB0),
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      like_button(
                        isLiked: isLiked,
                        onTap: toggleLike,
                      ),
                      comment_button(onTap: () {
                        showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            backgroundColor:
                                const Color.fromARGB(255, 255, 233, 233),
                            isScrollControlled: true,
                            builder: (_) {
                              return BottomSheetScreen(
                                  userUid: widget.userUid,
                                  postID: widget.postID);
                            });
                      }),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        widget.recipe.likes.length.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        widget.recipe.likes.length > 1 ? 'likes' : 'like',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the document in firebase
    DocumentReference postRef = userCollection
        .doc(widget.userUid)
        .collection('User Posts')
        .doc(widget.postID);

    if (isLiked) {
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUser.uid])
      });
    } else {
      //if the post is now unliked, remove the user's email from the likes field
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUser.uid])
      });
    }
  }

  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete Post'),
              content: const Text('Are tou sure you want to delete this post?'),
              actions: [
                //Cancel
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                //Delete
                TextButton(
                  onPressed: () async {
                    //delete the comments from firestore first

                    final commentDocs = await userCollection
                        .doc(widget.userUid)
                        .collection('User Posts')
                        .doc(widget.postID)
                        .collection('Comments')
                        .get();

                    for (var doc in commentDocs.docs) {
                      await userCollection
                          .doc(widget.userUid)
                          .collection('User Posts')
                          .doc(widget.postID)
                          .collection('Comments')
                          .doc(doc.id)
                          .delete();
                    }

                    //then delete the posts
                    userCollection
                        .doc(widget.userUid)
                        .collection('User Posts')
                        .doc(widget.postID)
                        .delete()
                        .then((value) => print('Post deleted'))
                        .catchError(
                            (error) => print('Fail to delete post: $error'));

                    //delete the dialogAlert
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                )
              ],
            ));
  }
}

class BottomSheetScreen extends StatefulWidget {
  final String userUid;
  final String postID;

  BottomSheetScreen({
    super.key,
    required this.userUid,
    required this.postID,
  });
  @override
  _BottomSheetScreenState createState() => _BottomSheetScreenState();
}

class _BottomSheetScreenState extends State<BottomSheetScreen> {
  final textController = TextEditingController();
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final currentUser = FirebaseAuth.instance.currentUser!;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Padding(
          padding: mediaQueryData.viewInsets,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: userCollection
                          .doc(widget.userUid)
                          .collection('User Posts')
                          .doc(widget.postID)
                          .collection('Comments')
                          .orderBy('CommentedTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final commentData = snapshot.data!.docs[index]
                                  .data() as Map<String, dynamic>;

                              final commentID = snapshot.data!.docs[index].id;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Comment(
                                  text: commentData['CommentText'],
                                  userUid: commentData['CommentedBy'],
                                  time: MyDateUtil.formatDate(
                                      commentData['CommentedTime']),
                                  onPressed: () => deleteComment(commentID),
                                ),
                              );
                            });
                      },
                    ),
                    const SizedBox(
                      height: 80,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: commentField(),
              ),
            ],
          )),
    );
  }

  Widget commentField() {
    return Expanded(
      child: Container(
        color: const Color.fromARGB(255, 255, 233, 233),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 30, top: 10),
                child: TextField(
                  controller: textController,
                  maxLines: null, // Set maxLines to null or a higher value
                  textAlignVertical: TextAlignVertical.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    hintText: 'Write your comment...',
                    hintStyle: const TextStyle(fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors
                            .white, // Set the color for the focused border line
                        width:
                            1, // Set the thickness for the focused border line
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (textController.text.trim().length > 1) {
                  addComment(textController.text);
                  textController.clear();
                }
              },
              child: const Text('Post'),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void addComment(String commentText) {
    //write the comment to firestore under the comments collection for this post
    userCollection
        .doc(widget.userUid)
        .collection('User Posts')
        .doc(widget.postID)
        .collection('Comments')
        .add({
      'CommentText': commentText,
      'CommentedBy': currentUser.uid,
      'CommentedTime': Timestamp.now(), //need to format this when display
    });

    scrollToTop();
  }

  void deleteComment(String commentID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          //Cancel
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          //Delete
          TextButton(
            onPressed: () async {
              //delete the comments from firestore first

              userCollection
                  .doc(widget.userUid)
                  .collection('User Posts')
                  .doc(widget.postID)
                  .collection('Comments')
                  .doc(commentID)
                  .delete();

              Navigator.pop(context);
            },
            child: const Text('Delete'),
          )
        ],
      ),
    );
  }
}
