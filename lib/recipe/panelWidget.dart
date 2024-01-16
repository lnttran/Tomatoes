import 'package:flutter/material.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/main.dart';

class panelWidget extends StatefulWidget {
  final ScrollController controller;
  final Recipe recipe;
  const panelWidget({
    super.key,
    required this.recipe,
    required this.controller,
  });

  @override
  State<panelWidget> createState() => _panelWidgetState();
}

class _panelWidgetState extends State<panelWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ListView(
        children: [
          _dragHandle(),
          const SizedBox(
            height: 20,
          ),
          _heading(context),
          const SizedBox(
            height: 20,
          ),
          _ingredientList(context),
          const SizedBox(
            height: 20,
          ),
          _instruction(context),
        ],
      ),
    );
  }

  Center _dragHandle() {
    return Center(
      child: Container(
        width: thisSize.width * 0.2,
        height: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _heading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items at the top
          children: [
            //title
            Expanded(
              child: Text(
                widget.recipe.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 33,
                    ),
              ),
            ),
            Row(
              children: [
                const SizedBox(
                  height: 49,
                ),
                Text(
                  '${widget.recipe.likes.length}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 23,
                      ),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.star,
                  size: 30,
                  color: Colors.yellow[700],
                )
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(widget.recipe.description,
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.schedule_outlined,
                  size: 30,
                  color: Color(0xFFF83015),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text('${widget.recipe.timeSpend} mins',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  size: 30,
                  color: Color(0xFFF83015),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '${widget.recipe.totalCal} calories',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.restaurant_outlined,
                  size: 30,
                  color: Color(0xFFF83015),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text('${widget.recipe.numOfServings} servings',
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _ingredientList(BuildContext context) {
    // Create a list of ingredients
    List<String> ingredients = widget.recipe.ingredients;

    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFFFE2DC),
          borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ingredients',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 20,
                      ),
                ),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 6, // Adjust the aspect ratio as needed
              ),
              itemCount: ingredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '${index + 1}. ' + ingredients[index],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _instruction(BuildContext context) {
    List<String> instructions = widget.recipe.steps;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFE2DC),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Instruction',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: instructions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '${index + 1}. ' + instructions[index],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
