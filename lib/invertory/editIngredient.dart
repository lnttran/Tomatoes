import 'package:flutter/material.dart';
import 'package:tomatoes/Components/label_textfield.dart';
import 'package:tomatoes/Components/material_button.dart';
import 'package:tomatoes/invertory/dropdownSearch.dart';
import 'package:tomatoes/invertory/ingredientsClass.dart';
import 'package:tomatoes/method/APIs.dart';

class editIngredient extends StatefulWidget {
  final IngredientClass ingredient;

  editIngredient({
    super.key,
    required this.ingredient,
  });
  @override
  State<editIngredient> createState() => _editIngredientState();
}

class _editIngredientState extends State<editIngredient> {
  final valueController = TextEditingController();
  final GlobalKey<FormState> valueFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              // FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: const Color(0xFFFFE2DC),
              ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const SizedBox(
                          width: 50,
                          height: 45,
                          child: Icon(Icons.arrow_back_ios),
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Text(
                        'Edit your ingredient',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 26),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Text(
                              'Category',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 500,
                        height: 49,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(187, 108, 108,
                                108), // Set your desired border color
                            width: 1.0, // Set your desired border width
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 14),
                          child: Text(
                            APIs.capitalizeFirstLetter(widget
                                .ingredient.category
                                .toString()
                                .split('.')
                                .last),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Text(
                              'Ingredient',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 500,
                        height: 49,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(187, 108, 108,
                                108), // Set your desired border color
                            width: 1.0, // Set your desired border width
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 14),
                          child: Text(
                            APIs.capitalizeFirstLetter(widget.ingredient.name
                                .toString()
                                .split('.')
                                .last),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Text(
                              'Value',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: label_texfield(
                              controller: valueController,
                              labelText: 'Value',
                              maxlines: 1,
                              maxlength: 10,
                              formkey: valueFormKey,
                              isNumber: true,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 30.0, left: 20),
                            child: Text(
                              widget.ingredient.countUnit
                                  .toString()
                                  .split('.')
                                  .last,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      material_button(
                        onTap: () {
                          widget.ingredient.value = valueController.text;
                          APIs.addIngredient(widget.ingredient);

                          Navigator.of(context).pop();
                        },
                        text: 'Update',
                      ),
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
