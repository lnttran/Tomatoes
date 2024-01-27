import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/Components/typeFilter.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/method/APIs.dart';
import 'package:tomatoes/recipe/filterfoodType.dart';
import 'package:tomatoes/recipe/recipeCard.dart';

class mainPage extends StatefulWidget {
  const mainPage({super.key});

  @override
  State<mainPage> createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');
  final ScrollController scrollController = ScrollController();
  final List<DocumentSnapshot> _searchList = [];
  final FocusNode _focusNode = FocusNode();
  bool gettingMoreProduct = false;
  bool moreProductAvailable = true;
  bool isTextFieldFocused = false;
  List<DocumentSnapshot> listOfRecipes = [];
  bool isLoading = true;
  int numOfRecipePerPage = 20;
  late DocumentSnapshot? lastDocument;
  Set<TypeFilter> selectedTypes = <TypeFilter>{};

  getRecipe() async {
    Query recipesQuery;
    // Set<typeFilter> selectedType = filterFoodTypeInstance.getSelectedType();
    if (selectedTypes.isEmpty) {
      recipesQuery = FirebaseFirestore.instance
          .collection('Recipes')
          .limit(numOfRecipePerPage);
    } else {
      recipesQuery = FirebaseFirestore.instance
          .collection('Recipes')
          .where('tags',
              arrayContainsAny: selectedTypes.map((type) => type.value))
          .limit(numOfRecipePerPage);
    }

    setState(() {
      isLoading = true;
    });

    QuerySnapshot querySnapshot = await recipesQuery.get();
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    listOfRecipes = querySnapshot.docs;
    setState(() {
      isLoading = false;
    });
  }

  getMoreRecipe() async {
    print("getMoreRecipe function is called");
    Query recipesQuery;
    // Set<typeFilter> selectedType = filterFoodTypeInstance.getSelectedType();
    if (selectedTypes.isEmpty) {
      recipesQuery = FirebaseFirestore.instance
          .collection('Recipes')
          .limit(numOfRecipePerPage);
    } else {
      recipesQuery = FirebaseFirestore.instance
          .collection('Recipes')
          .where('tags',
              arrayContainsAny: selectedTypes.map((type) => type.value))
          .startAfterDocument(lastDocument!)
          .limit(numOfRecipePerPage);
    }

    QuerySnapshot querySnapshot = await recipesQuery.get();
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    listOfRecipes.addAll(querySnapshot.docs);
    setState(() {
      // isLoading = false;
    });
  }

  getRecentlyViewList() async {
    DocumentSnapshot userSnapshot =
        await userCollection.doc(currentUser.uid).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    List<dynamic> recentlyViewList = userData['RecentlyView'];
    if (recentlyViewList.isEmpty) {
      List<String> first10Recipes =
          listOfRecipes.take(10).map((recipe) => recipe.id).toList();

      // Update Firestore with the first 10 recipes
      await userCollection
          .doc(currentUser.uid)
          .update({'RecentlyView': first10Recipes});
    }
  }

  void handleSelectedFilterChange(Set<TypeFilter> thisSelectedTypes) {
    setState(() {
      lastDocument = null;
      selectedTypes = thisSelectedTypes;
    });
    // Fetch the initial set of recipes with the new selectedType
    getRecipe();
  }

  @override
  void initState() {
    super.initState();

    getRecipe();
    getRecentlyViewList();
    scrollController.addListener(() {
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;

      if (maxScroll - currentScroll <= delta) {
        getMoreRecipe();
      }
    });

    _focusNode.addListener(() {
      setState(() {
        isTextFieldFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //set to track the selected data
    // Set<tags> selectedTags = Set<tags>(); // To store selected tags
    return SafeArea(
      child: SingleChildScrollView(
        physics: isTextFieldFocused
            ? const NeverScrollableScrollPhysics()
            : const ScrollPhysics(),
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isTextFieldFocused)
                StreamBuilder<DocumentSnapshot>(
                  stream: userCollection.doc(currentUser.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userData =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Row(
                        children: [
                          ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(thisSize.height * .3),
                              child: CachedNetworkImage(
                                width: thisSize.width * .15,
                                height: thisSize.width * .15,
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
                                  width: thisSize.width * .15,
                                  height: thisSize.width * .15,
                                  decoration: const BoxDecoration(
                                    //shape: BoxShape.circle,
                                    color: Color(0xFFF83015),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Hi ${userData['First_name']},',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: Colors.black,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),

              if (!isTextFieldFocused)
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    //Search bar

                    Row(
                      children: [
                        Text(
                          'Get your recipe!',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),

              // search box
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        hintText: 'Search',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: Colors.grey),
                        filled: true,
                        fillColor: const Color(0xFFFFE2DC),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(
                                0xFFF83015), // Set the color for the focused border line
                            width:
                                2, // Set the thickness for the focused border line
                          ),
                        ),
                      ),
                      onChanged: (value) async {
                        _searchList.clear();
                        Query recipesQuery =
                            FirebaseFirestore.instance.collection('Recipes');
                        QuerySnapshot querySnapshot = await recipesQuery.get();
                        List<DocumentSnapshot> list = querySnapshot.docs;

                        for (var i in list) {
                          final recipe = i.data() as Map<String, dynamic>;
                          if (recipe['name']
                              .toLowerCase()
                              .contains(value.toLowerCase())) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                    ),
                  ),
                  if (isTextFieldFocused)
                    TextButton(
                      onPressed: () {
                        _focusNode.unfocus();
                        _searchList.clear();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFFF83015),
                        ),
                      ),
                    ),
                ],
              ),

              if (!isTextFieldFocused)
                Column(
                  children: [
                    FilterFoodType(
                      onSelectedTypeChange: handleSelectedFilterChange,
                    ),
                    /**
                     * Recently view section 
                     */
                    Row(
                      children: [
                        Text(
                          'Recently views',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                  ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 200,
                      child: StreamBuilder(
                          stream:
                              userCollection.doc(currentUser.uid).snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              List<dynamic> recentlyViewList =
                                  userData['RecentlyView'];
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recentlyViewList.length,
                                  itemBuilder: (context, index) {
                                    final currentRecipeID =
                                        recentlyViewList[index];
                                    return StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('Recipes')
                                            .doc(currentRecipeID)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            final recipeData = snapshot.data!
                                                .data() as Map<String, dynamic>;
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 15.0),
                                              child: recipeCard(
                                                onRecipeCardClicked: () =>
                                                    APIs.onRecipeCardClicked(
                                                        currentRecipeID),
                                                recentlyView: true,
                                                recipe:
                                                    Recipe.fromJson(recipeData),
                                                isFave: true,
                                                recipeUID: currentRecipeID,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'),
                                            );
                                          }
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        });
                                  });
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Main Course',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                  ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(
                height: isTextFieldFocused ? 20 : 10,
              ),
              if (isLoading == true)
                const Center(child: CircularProgressIndicator()),
              ListView.builder(
                shrinkWrap: true,
                physics: isTextFieldFocused
                    ? null
                    : const NeverScrollableScrollPhysics(),
                itemCount: isTextFieldFocused
                    ? _searchList.length
                    : listOfRecipes.length,
                itemBuilder: ((context, index) {
                  final recipeID = isTextFieldFocused
                      ? _searchList[index].id
                      : listOfRecipes[index].id;
                  final recipe = isTextFieldFocused
                      ? _searchList[index].data() as Map<String, dynamic>
                      : listOfRecipes[index].data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: recipeCard(
                      onRecipeCardClicked: () =>
                          APIs.onRecipeCardClicked(recipeID),
                      recentlyView: false,
                      recipe: Recipe.fromJson(recipe),
                      isFave: true,
                      recipeUID: recipeID,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
