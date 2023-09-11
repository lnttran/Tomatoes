import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/comment.dart';
import 'package:tomatoes/Components/delete_button.dart';
import 'package:tomatoes/Components/like_button.dart';
import 'package:tomatoes/Components/comment_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/method/convertTime.dart';

class userPost extends StatefulWidget {
  final String recipe;
  final String user;
  final String postID;
  final List<String> likes;

  const userPost({
    super.key,
    required this.recipe,
    required this.user,
    required this.postID,
    required this.likes,
  });

  @override
  State<userPost> createState() => _userPostState();
}

class _userPostState extends State<userPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final commentTextController = TextEditingController();
  final userCollection = FirebaseFirestore.instance.collection('Users');
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    //Access the document in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postID);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      //if the post is now unliked, remove the user's email from the likes field
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // add a comment
  void addComment(String commentText) {
    //write the comment to firestore under the comments collection for this post
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postID)
        .collection('Comments')
        .add({
      'CommentText': commentText,
      'CommentedBy': currentUser.email,
      'CommentedTime': Timestamp.now(), //need to format this when display
    });
  }

  void deleteComment(String commentID) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Delete Post'),
                content:
                    const Text('Are you sure you want to delete this comment?'),
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

                      FirebaseFirestore.instance
                          .collection('User Posts')
                          .doc(widget.postID)
                          .collection('Comments')
                          .doc(commentID)
                          .delete();

                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  )
                ]));
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

                    final commentDocs = await FirebaseFirestore.instance
                        .collection('User Posts')
                        .doc(widget.postID)
                        .collection('Comments')
                        .get();

                    for (var doc in commentDocs.docs) {
                      await FirebaseFirestore.instance
                          .collection('User Posts')
                          .doc(widget.postID)
                          .collection('Comments')
                          .doc(doc.id)
                          .delete();
                    }

                    //then delete the posts
                    FirebaseFirestore.instance
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      //geting the information of Users->widget.user.email
      stream: userCollection.doc(widget.user).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFE2DC),
              borderRadius: BorderRadius.circular(25),
            ),
            margin: EdgeInsets.only(
              top: 15,
              left: 5,
              right: 5,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                            width: 10,
                          ),
                          Text(
                            widget.user,
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ],
                      ),
                      if (widget.user == currentUser.email)
                        delete_button(
                          onTap: deletePost,
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(widget.recipe),
                  Divider(
                    color: Color(0xFFFFBFB0),
                    thickness: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      like_button(
                        isLiked: isLiked,
                        onTap: toggleLike,
                      ),
                      comment_button(
                        onTap: () {
                          _showBottomSheet(context);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0),
                    child: Row(
                      children: [
                        Text(
                          widget.likes.length.toString(),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          widget.likes.length > 1 ? 'likes' : 'like',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
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
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Color(0xFFFFE2DC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
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

                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((doc) {
                        final commentData = doc.data() as Map<String, dynamic>;
                        final commentID = doc.id;

                        return Comment(
                          text: commentData['CommentText'],
                          user: commentData['CommentedBy'],
                          time: MyDateUtil.formatDate(
                              commentData['CommentedTime']),
                          onPressed: () => deleteComment(commentID),
                        );
                      }).toList(),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: commentField(),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      commentTextController.clear();
    });
  }

  Row commentField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: commentTextController,
            style: Theme.of(context).textTheme.headlineSmall,
            decoration: InputDecoration(
              hintText: 'Write your comment...',
              hintStyle: TextStyle(fontSize: 14),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (commentTextController.text.trim().length > 1) {
              addComment(commentTextController.text);
              commentTextController.clear();
            }
          },
          child: Text('Post'),
        ),
      ],
    );
  }
}
