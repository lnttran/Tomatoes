import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tomatoes/Components/recipe.dart';
import 'package:tomatoes/main.dart';
import 'package:tomatoes/recipe/PanelWidget.dart';

class recipePage extends StatefulWidget {
  final Recipe recipe;
  const recipePage({
    super.key,
    required this.recipe,
  });

  @override
  State<recipePage> createState() => _recipePageState();
}

class _recipePageState extends State<recipePage> {
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
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.recipe.thumbnail),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: const Color(
                    0xFFFFE2DC), // Set the background color of the button
                shape: const CircleBorder(), // Make the button circular
                child: const Padding(
                  padding: EdgeInsets.all(16.0), // Adjust padding as needed
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black, // Set the icon color
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: const Color(
                    0xFFFFE2DC), // Set the background color of the button
                shape: const CircleBorder(), // Make the button circular
                child: const Padding(
                  padding: EdgeInsets.all(16.0), // Adjust padding as needed
                  child: Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.black, // Set the icon color
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
