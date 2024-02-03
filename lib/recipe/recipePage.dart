import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/recipe/PanelWidget.dart';

class recipePage extends StatefulWidget {
  final Recipe recipe;
  final bool isFav;
  final String? recipeUID;

  const recipePage({
    super.key,
    required this.recipe,
    required this.isFav,
    this.recipeUID,
  });

  @override
  State<recipePage> createState() => _recipePageState();
}

class _recipePageState extends State<recipePage> {
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

          setState(() {
            isLiked = favoriteRecipes.contains(widget.recipeUID);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingUpPanel(
      maxHeight: thisSize.height,
      minHeight: thisSize.height * 0.5,
      parallaxEnabled: true,
      parallaxOffset: .5,
      body: _body(context),
      panelBuilder: (controller) => panelWidget(
        controller: controller,
        recipe: widget.recipe,
      ),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ));
  }

  Stack _body(BuildContext context) {
    print("Thumbnail URL: ${widget.recipe.thumbnail}");
    return Stack(
      children: [
        if (widget.recipe.thumbnail.isNotEmpty)
          // Image.network(
          //   widget.recipe.thumbnail,
          //   fit: BoxFit.cover, // You can adjust the fit as per your needs
          //   width: double.infinity, // Set width to fill the container
          //   height: double.infinity, // Set height to fill the container
          // )
          CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            imageUrl: widget.recipe.thumbnail,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/startBG.jpg',
              fit: BoxFit.cover, // You can adjust the fit as per your needs
              width: double.infinity, // Set width to fill the container
              height: double.infinity,
            ),

            // Container(
            //   width: thisSize.height * .055,
            //   height: thisSize.height * .055,
            //   decoration: const BoxDecoration(
            //     //shape: BoxShape.circle,
            //     color: Color(0xFFF83015),
            //   ),
            //   child: const Icon(
            //     Icons.person,
            //     color: Colors.white,
            //   ),
            // ),
          ),
        // else
        //   Image.asset(
        //     'assets/images/startBG.jpg',
        //     fit: BoxFit.cover, // You can adjust the fit as per your needs
        //     width: double.infinity, // Set width to fill the container
        //     height: double.infinity,
        //   ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: const Color.fromARGB(200, 255, 226,
                    220), // Set the background color of the button
                shape: const CircleBorder(), // Make the button circular
                child: const Padding(
                  padding: EdgeInsets.all(16.0), // Adjust padding as needed
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black, // Set the icon color
                  ),
                ),
              ),
              if (widget.isFav)
                MaterialButton(
                  onPressed: toggleLike,
                  color: const Color.fromARGB(200, 255, 226,
                      220), // Set the background color of the button
                  shape: const CircleBorder(), // Make the button circular
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16.0), // Adjust padding as needed
                    child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color:
                            isLiked ? const Color(0xFFF83015) : Colors.black),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
