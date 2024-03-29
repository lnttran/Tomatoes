import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/like_button.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/recipe/recipePage.dart';

class recipeCard extends StatefulWidget {
  final bool recentlyView;
  final Recipe recipe;
  final bool isFave;
  final VoidCallback onRecipeCardClicked;
  final String? recipeUID;
  const recipeCard({
    super.key,
    required this.recentlyView,
    required this.recipe,
    required this.isFave,
    required this.onRecipeCardClicked,
    this.recipeUID,
  });

  @override
  State<recipeCard> createState() => _recipeCardState();
}

class _recipeCardState extends State<recipeCard> {
  bool isLiked = false;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');

  void toggleLike() {
    if (mounted) {
      setState(() {
        isLiked = !isLiked;
      });
    }

    DocumentReference userRef = userCollection.doc(currentUser.uid);

    if (isLiked) {
      userRef.update({
        'FavoriteRecipe': FieldValue.arrayUnion([widget.recipeUID])
      });
    } else {
      userRef.update({
        'FavoriteRecipe': FieldValue.arrayRemove([widget.recipeUID])
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userCollection.doc(currentUser.uid).get().then((DocumentSnapshot snapshot) {
      if (mounted) {
        if (snapshot.exists) {
          final userData = snapshot.data() as Map<String, dynamic>;
          final favoriteRecipes =
              List<String>.from(userData['FavoriteRecipe'] ?? []);

          // Check if the RecipeUID is in the favorite list
          setState(() {
            isLiked = favoriteRecipes.contains(widget.recipeUID);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onRecipeCardClicked();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => recipePage(
                recipe: widget.recipe,
                isFav: widget.isFave,
                recipeUID: widget.recipeUID,
              ),
            ));
      },
      child: widget.recentlyView
          ? _buildCardWithoutSlidable(context, true, widget.isFave)
          : _buildCardWithoutSlidable(context, false, widget.isFave),
    );
  }

  // Slidable _buildCardWithSlidable(BuildContext context) {
  //   return Slidable(
  //     endActionPane: ActionPane(
  //       motion: DrawerMotion(),
  //       children: [
  //         Expanded(
  //           child: Align(
  //             alignment: Alignment.centerRight,
  //             child: InkWell(
  //               onTap: () {},
  //               child: Container(
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                     color: Color(0xFF211B25),
  //                     borderRadius: BorderRadius.circular(25),
  //                   ),
  //                   child: Icon(
  //                     Icons.delete_outline,
  //                     color: Colors.white,
  //                   )),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Align(
  //             alignment: Alignment.centerRight,
  //             child: InkWell(
  //               onTap: () {},
  //               child: Container(
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                     color: Color(0xFFF83015),
  //                     borderRadius: BorderRadius.circular(25),
  //                   ),
  //                   child: Icon(
  //                     Icons.article_outlined,
  //                     color: Colors.white,
  //                   )),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     child: _buildCardWithoutSlidable(context, false),
  //   );
  // }

  Container _buildCardWithoutSlidable(
      BuildContext context, bool recentlyV, bool isFav) {
    final imageDecorationBuilder =
        ImageDecorationBuilder(widget.recipe.thumbnail);
    return Container(
      width: recentlyV ? thisSize.width * 0.85 : thisSize.width * 0.90,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2DC), // Replace with your desired color
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: thisSize.width * 0.35,
                  height: 180,
                  decoration: BoxDecoration(
                    image: imageDecorationBuilder.buildImageDecoration(),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0), // Add padding for text
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.recipe.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                      height:
                          10), // Add space between the title and description
                  Text(
                    widget.recipe.description,
                    style: Theme.of(context).textTheme.titleSmall,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                      height:
                          10), // Add space between the description and the row of containers
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: recentlyV
                              ? thisSize.width * 0.19
                              : thisSize.width * 0.21,
                          height: 30, // Adjust the height as needed
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFFF998B), // Replace with your desired color
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: recentlyV ? 4.0 : 5.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.schedule_outlined),
                                  Text('${widget.recipe.timeSpend} mins',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(fontSize: 13)),
                                ],
                              ),
                            ),
                          )),
                      //SizedBox(width: 5), // Add space between the containers

                      Container(
                        width: recentlyV
                            ? thisSize.width * 0.14
                            : thisSize.width * 0.17,
                        height: 30, // Adjust the height as needed
                        decoration: BoxDecoration(
                          color: const Color(
                              0xFFFFD703), // Replace with your desired color
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: recentlyV ? 7.0 : 13.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('4.8',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(fontSize: 13)),
                                  const Icon(Icons.star),
                                ]),
                          ),
                        ),
                      ),
                      if (isFav)
                        like_button(isLiked: isLiked, onTap: toggleLike),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DecorationImage _buildImageDecoration() {
  //   if (widget.recipe.thumbnail != null && widget.recipe.thumbnail.isNotEmpty) {
  //     return DecorationImage(
  //       image: NetworkImage(widget.recipe.thumbnail),
  //       fit: BoxFit.cover,
  //     );
  //   } else {
  //     // Handle the case when thumbnail is null or empty
  //     return const DecorationImage(
  //       // Show an existing image when thumbnail is null or empty
  //       image: AssetImage('assets/images/startBG.jpg'),
  //       fit: BoxFit.cover,
  //     );
  //   }
  // }
}

class ImageDecorationBuilder {
  final String imageUrl;

  ImageDecorationBuilder(this.imageUrl);

  DecorationImage buildImageDecoration() {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(imageUrl),
        fit: BoxFit.cover,
      );
    } else {
      // Handle the case when thumbnail is null or empty
      return const DecorationImage(
        // Show an existing image when thumbnail is null or empty
        image: AssetImage('assets/images/startBG.jpg'),
        fit: BoxFit.cover,
      );
    }
  }
}
