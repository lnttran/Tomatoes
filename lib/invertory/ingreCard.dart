import 'package:flutter/material.dart';
import 'package:tomatoes/invertory/ingredientsClass.dart';

class ingredientCard extends StatefulWidget {
  final IngredientClass ingredient;
  final VoidCallback onDelete;
  const ingredientCard({
    super.key,
    required this.ingredient,
    required this.onDelete,
  });

  @override
  State<ingredientCard> createState() => _ingredientCardState();
}

class _ingredientCardState extends State<ingredientCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
          ),
          Icon(Icons.edit),
        ],
      ),
      // decoration: const BoxDecoration(
      //     color: Colors.black,
      //     borderRadius: BorderRadius.only(
      //         bottomRight: Radius.circular(15),
      //         topRight: Radius.circular(15))),

      secondaryBackground: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.delete),
          SizedBox(
            width: 40,
          ),
        ],
      ),
      key: ValueKey(widget.ingredient.name),
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.startToEnd) {
        } else if (direction == DismissDirection.endToStart) {
          widget.onDelete();
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        color: const Color(0xFFFFE2DC),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      height: 30,
                      child: Image.asset(widget.ingredient.iconImage)),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    capitalizeFirstLetter(widget.ingredient.name),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${widget.ingredient.value}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    widget.ingredient.countUnit.toString().split('.').last,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
  }
}
