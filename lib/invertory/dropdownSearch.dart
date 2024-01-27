import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownSearch<T> extends StatefulWidget {
  final List<T> items;
  final String Function(dynamic) displayItemString;
  final void Function(T?) onChange;
  final T? selectedItem;
  const CustomDropdownSearch({
    super.key,
    required this.items,
    required this.displayItemString,
    required this.onChange,
    this.selectedItem,
  });

  @override
  State<CustomDropdownSearch<T>> createState() =>
      _CustomDropdownSearchState<T>();
}

class _CustomDropdownSearchState<T> extends State<CustomDropdownSearch<T>> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: widget.items,
      compareFn: (T? selectedItem, T? itemToCompare) {
        return selectedItem == itemToCompare;
      },
      itemAsString: widget.displayItemString,
      onChanged: (T? selectedItem) {
        widget.onChange.call(selectedItem);
      },
      selectedItem: widget.selectedItem,
      // dropdownBuilder: _customDropDownBuilder,
      dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color.fromARGB(187, 108, 108, 108),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(15),
              //   topRight: Radius.circular(15),
              // ),
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color.fromARGB(187, 108, 108,
                    108), // Set the color for the focused border line
                width: 1, // Set the thickness for the focused border line
              ),
            ),
          ),
          baseStyle: Theme.of(context).textTheme.headlineSmall),
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        // itemBuilder: _customPopupItemBuilder,
        searchFieldProps: TextFieldProps(
            style: Theme.of(context).textTheme.headlineSmall,
            cursorColor: Colors.black38,
            cursorHeight: 20,
            cursorWidth: 2,
            decoration: InputDecoration(
              hintText: 'Search',
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              suffixIcon: const Icon(Icons.search),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(width: 1)),
              hintStyle: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: const Color.fromARGB(182, 111, 111, 111)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            )),
        showSearchBox: true,
        menuProps: const MenuProps(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            elevation: 0),
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    return text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;
  }

  // Widget _customPopupItemBuilder(
  //     BuildContext context, dynamic item, bool isSelected) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 15),
  //     decoration: !isSelected
  //         ? null
  //         : const BoxDecoration(
  //             color: Color.fromARGB(190, 255, 226, 220),
  //           ),
  //     child: Text(capitalizeFirstLetter(widget.displayItemString(item)),
  //         style: Theme.of(context).textTheme.headlineSmall),
  //   );
  // }

  // Widget _customDropDownBuilder(BuildContext context, dynamic selectedItem) {
  //   return Container(
  //     child: (selectedItem == null)
  //         ? const Text(
  //             "",
  //           )
  //         : Text(
  //             capitalizeFirstLetter(widget.displayItemString(selectedItem)),
  //             textAlign: TextAlign.left,
  //             overflow: TextOverflow.ellipsis,
  //             style: const TextStyle(fontSize: 13.5, color: Colors.black),
  //           ),
  //   );
  // }
}
