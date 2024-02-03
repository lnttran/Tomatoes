import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tomatoes/invertory/editIngredient.dart';
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
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => editIngredient(
                          ingredient: widget.ingredient,
                        ),
                      ));
                },
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Color(0xFFF83015),
                    )),
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  widget.onDelete();
                },
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // color: Color(0xFF211B25),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFF211B25),
                    )),
              ),
            ),
          ),
        ],
      ),
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
