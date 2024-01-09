import 'package:flutter/material.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/recipe/recipePage.dart';

class recipeCard extends StatefulWidget {
  final bool recentlyView;
  final Recipe recipe;
  final bool isFave;
  const recipeCard({
    super.key,
    required this.recentlyView,
    required this.recipe,
    required this.isFave,
  });

  @override
  State<recipeCard> createState() => _recipeCardState();
}

class _recipeCardState extends State<recipeCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => recipePage(
                recipe: widget.recipe,
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
                      image: DecorationImage(
                        //image: AssetImage('assets/images/startBG.jpg'),
                        image: NetworkImage(widget.recipe.thumbnail),
                        fit: BoxFit.cover,
                      ),
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
                    SizedBox(
                        height:
                            10), // Add space between the title and description
                    Text(
                      widget.recipe.description,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
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
                                  horizontal: recentlyV ? 3.0 : 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.schedule_outlined),
                                    Text(
                                        widget.recipe.timeSpend.toString() +
                                            ' mins',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
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
                                  horizontal: recentlyV ? 7.0 : 10.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('4.8',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                    const Icon(Icons.star),
                                  ]),
                            ),
                          ),
                        ),
                        if (isFav) const Icon(Icons.favorite_border_outlined),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
