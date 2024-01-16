import 'package:flutter/material.dart';

enum typeFilter {
  Main,
  Breakfast,
  Vegan,
  All,
  Soup,
  Beef,
  Japeneses,
}

class FilterFoodType extends StatefulWidget {
  const FilterFoodType({super.key});
  @override
  State<FilterFoodType> createState() => _FilterFoodType();
}

class _FilterFoodType extends State<FilterFoodType> {
  Set<typeFilter> selectedType = <typeFilter>{};

  @override
  Widget build(BuildContext context) {
    // final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 70,
      child: ListView.builder(
          itemCount: typeFilter.values.length,
          scrollDirection: Axis.horizontal, // Scroll horizontally
          itemBuilder: (context, index) {
            final tag = typeFilter.values[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilterChip(
                label: Text(tag.name),
                selected: selectedType.contains(tag),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedType.add(tag);
                    } else {
                      selectedType.remove(tag);
                    }
                  });
                },
                backgroundColor: const Color(0xFFFFE2DC),
                selectedColor: const Color(0xFFF83015),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(25.0), // Define the border radius
                ),
                labelStyle: TextStyle(
                  color: selectedType.contains(tag)
                      ? Colors.white // Text color when selected
                      : Colors.black, // Text color when unselected
                ),
              ),
            );
          }),
    );
  }
}
