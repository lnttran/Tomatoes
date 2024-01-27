import 'package:flutter/material.dart';
import 'package:tomatoes/Components/typeFilter.dart';

// enum typeFilter {
//   occasion,
//   healthy,
//   appetizers,
// }

class FilterFoodType extends StatefulWidget {
  final void Function(Set<TypeFilter> selectedTypes)? onSelectedTypeChange;
  const FilterFoodType({super.key, this.onSelectedTypeChange});
  @override
  State<FilterFoodType> createState() => _FilterFoodType();
  Set<TypeFilter> getSelectedType() {
    return _FilterFoodType().selectedType;
  }
}

class _FilterFoodType extends State<FilterFoodType> {
  Set<TypeFilter> selectedType = <TypeFilter>{};

  @override
  Widget build(BuildContext context) {
    // final TextTheme textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 70,
      child: ListView.builder(
          itemCount: TypeFilterStorage.filters.length,
          scrollDirection: Axis.horizontal, // Scroll horizontally
          itemBuilder: (context, index) {
            final tag = TypeFilterStorage.filters[index];
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
                  if (widget.onSelectedTypeChange != null) {
                    widget.onSelectedTypeChange!(selectedType);
                  }
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
