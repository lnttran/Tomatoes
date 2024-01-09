import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tomatoes/invertory/ingreCard.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class inventoryPage extends StatefulWidget {
  const inventoryPage({super.key});

  @override
  State<inventoryPage> createState() => _inventoryPageState();
}

class _inventoryPageState extends State<inventoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft, // Align text to the left
          child: Row(
            children: [
              Text(
                'My Inventory',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Protein',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
              ingredientCard(icon: Icon(Icons.egg), type: 'Egg'),
              ingredientCard(icon: Icon(Icons.egg), type: 'Beef'),
              ingredientCard(icon: Icon(Icons.egg), type: 'Chicken'),
              ingredientCard(icon: Icon(Icons.egg), type: 'Pork'),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Vegetables',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
              ingredientCard(icon: Icon(Icons.bakery_dining), type: 'Lettuce'),
              ingredientCard(icon: Icon(Icons.rice_bowl), type: 'Tomato'),
              ingredientCard(icon: Icon(Icons.bakery_dining), type: 'Lettuce'),
              ingredientCard(icon: Icon(Icons.rice_bowl), type: 'Tomato'),
              ingredientCard(icon: Icon(Icons.bakery_dining), type: 'Lettuce'),
              ingredientCard(icon: Icon(Icons.rice_bowl), type: 'Tomato'),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //use ClipRRect to clip its child. (Clip rounded rectangle)
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: SizedBox(
          width: 200,
          height: 50,
          child: FloatingActionButton(
              onPressed: exportData,
              backgroundColor: Color(0xFFF83015),
              elevation: 10,
              splashColor: const Color.fromARGB(
                  255, 171, 0, 0), // Set the splash color when clicked
              highlightElevation:
                  8, // Set the elevation during click (higher than regular elevation)
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Find recipe',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void exportData() {
    final CollectionReference recipes =
        FirebaseFirestore.instance.collection('Recipes');
  }
}
