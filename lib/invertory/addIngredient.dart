import 'package:flutter/material.dart';
import 'package:tomatoes/Components/label_textfield.dart';
import 'package:tomatoes/Components/material_button.dart';
import 'package:tomatoes/invertory/dropdownSearch.dart';
import 'package:tomatoes/invertory/ingredientsClass.dart';
import 'package:tomatoes/method/APIs.dart';

class addIngredient extends StatefulWidget {
  @override
  State<addIngredient> createState() => _addIngredientState();
}

class _addIngredientState extends State<addIngredient> {
  IngredientCategory? ingredientCategorySelection;
  IngredientClass? ingredientClassSelection;
  final valueController = TextEditingController();
  final GlobalKey<FormState> valueFormKey = GlobalKey<FormState>();

  void onCategoryChanged(IngredientCategory? category) {
    setState(() {
      ingredientCategorySelection = category!;
    });
  }

  void onIngredientChanged(IngredientClass? ingredient) {
    setState(() {
      ingredientClassSelection = ingredient!;
    });
  }

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
                        'Add your ingredient',
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
                      CustomDropdownSearch<IngredientCategory>(
                        items: IngredientCategory.values,
                        displayItemString: (item) {
                          return item.toString().split('.').last;
                        },
                        onChange: onCategoryChanged,
                        selectedItem: ingredientClassSelection?.category,
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
                      CustomDropdownSearch<IngredientClass>(
                        items: ingredientCategorySelection == null
                            ? IngredientStorage.ingredientStorage
                            : IngredientStorage.getDataByIngredientCategory(
                                ingredientCategorySelection!),
                        displayItemString: (item) {
                          return item.name;
                        },
                        onChange: onIngredientChanged,
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
                              ingredientClassSelection != null
                                  ? ingredientClassSelection!.countUnit
                                      .toString()
                                      .split('.')
                                      .last
                                  : 'pounds',
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
                          if (ingredientCategorySelection != null) {
                            ingredientClassSelection!.value =
                                valueController.text;
                            APIs.addIngredient(ingredientClassSelection!);
                          }
                          Navigator.of(context).pop();
                        },
                        text: 'Add',
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
