import 'package:flutter/material.dart';

enum CountType {
  double,
  whole,
}

enum CountUnit {
  kg,
  pounds,
  grams,
  counts,
  oz,
  loads,
}

enum IngredientCategory {
  dairy,
  protein,
  vegetables,
  carbohydrates,
  fruits,
  herbs,
}

class IngredientClass {
  late String name;
  late String iconImage;
  late CountUnit countUnit;
  late IngredientCategory category;
  dynamic value;

  IngredientClass(
      {required this.name,
      required this.category,
      required this.iconImage,
      required this.countUnit,
      required this.value});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': iconImage,
      'countUnit': countUnit.toString().split('.').last,
      'category': category.toString().split('.').last,
      'value': value,
    };
  }

  IngredientClass.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String;
    category = _convertStringToIngredientCategory(json['category'] as String);
    iconImage = json['icon'] as String;
    countUnit = _convertStringToCountUnit(json['countUnit'] as String);
    value = json['value'];
  }

  IngredientCategory _convertStringToIngredientCategory(String categoryString) {
    return IngredientCategory.values.firstWhere(
      (category) => category.toString().split('.').last == categoryString,
    );
  }

  CountUnit _convertStringToCountUnit(String countUnitString) {
    return CountUnit.values.firstWhere(
      (unit) => unit.toString().split('.').last == countUnitString,
    );
  }
}

class IngredientStorage {
  static final List<IngredientClass> ingredientStorage = [
    IngredientClass(
        name: 'milk',
        category: IngredientCategory.dairy,
        iconImage: 'assets/icons/dairy-products.png',
        countUnit: CountUnit.oz,
        value: 0.0),
    IngredientClass(
        name: 'butter',
        category: IngredientCategory.dairy,
        iconImage: 'assets/icons/dairy-products.png',
        countUnit: CountUnit.oz,
        value: 0.0),
    IngredientClass(
        name: 'cheese',
        category: IngredientCategory.dairy,
        iconImage: 'assets/icons/dairy-products.png',
        countUnit: CountUnit.oz,
        value: 0.0),
    IngredientClass(
        name: 'yogurt',
        category: IngredientCategory.dairy,
        iconImage: 'assets/icons/dairy-products.png',
        countUnit: CountUnit.oz,
        value: 0.0),
    IngredientClass(
        name: 'whipping cream',
        category: IngredientCategory.dairy,
        iconImage: 'assets/icons/dairy-products.png',
        countUnit: CountUnit.oz,
        value: 0.0),
    IngredientClass(
        name: 'sour cream',
        category: IngredientCategory.dairy,
        iconImage: 'assets/icons/dairy-products.png',
        countUnit: CountUnit.oz,
        value: 0.0),
    IngredientClass(
        name: 'chicken',
        category: IngredientCategory.protein,
        iconImage: 'assets/icons/chicken-leg.png',
        countUnit: CountUnit.pounds,
        value: 0.0),
    IngredientClass(
        name: 'beef',
        category: IngredientCategory.protein,
        iconImage: 'assets/icons/meat.png',
        countUnit: CountUnit.pounds,
        value: 0.0),
    IngredientClass(
        name: 'fish',
        category: IngredientCategory.protein,
        iconImage: 'assets/icons/salmon.png',
        countUnit: CountUnit.pounds,
        value: 0.0),
    IngredientClass(
        name: 'turkey',
        category: IngredientCategory.protein,
        iconImage: 'assets/icons/turkey.png',
        countUnit: CountUnit.counts,
        value: 0),
    IngredientClass(
        name: 'pork',
        category: IngredientCategory.protein,
        iconImage: 'assets/icons/meat-2.png',
        countUnit: CountUnit.counts,
        value: 0),
    IngredientClass(
        name: 'lamb',
        category: IngredientCategory.protein,
        iconImage: 'assets/icons/meat-3.png',
        countUnit: CountUnit.counts,
        value: 0),
    IngredientClass(
        name: 'rice',
        category: IngredientCategory.carbohydrates,
        iconImage: 'assets/icons/carb.png',
        countUnit: CountUnit.pounds,
        value: 0.0),
    IngredientClass(
        name: 'rice',
        category: IngredientCategory.carbohydrates,
        iconImage: 'assets/icons/carb.png',
        countUnit: CountUnit.pounds,
        value: 0.0),
    IngredientClass(
        name: 'pasta',
        category: IngredientCategory.carbohydrates,
        iconImage: 'assets/icons/carb.png',
        countUnit: CountUnit.pounds,
        value: 0.0),
    IngredientClass(
        name: 'bread',
        category: IngredientCategory.carbohydrates,
        iconImage: 'assets/icons/carb.png',
        countUnit: CountUnit.loads,
        value: 0.0),
    IngredientClass(
        name: 'potatoes',
        category: IngredientCategory.carbohydrates,
        iconImage: 'assets/icons/carb.png',
        countUnit: CountUnit.pounds,
        value: 0.0),
    IngredientClass(
        name: 'oats',
        category: IngredientCategory.carbohydrates,
        iconImage: 'assets/icons/carb.png',
        countUnit: CountUnit.pounds,
        value: 0.0),
    IngredientClass(
        name: 'broccoli',
        category: IngredientCategory.vegetables,
        iconImage: 'assets/icons/broccoli.png',
        countUnit: CountUnit.pounds,
        value: 0.0),
  ];

  static List<IngredientClass> getDataByIngredientCategory(
      IngredientCategory category) {
    return ingredientStorage
        .where((ingredient) => ingredient.category == category)
        .toList();
  }
}
