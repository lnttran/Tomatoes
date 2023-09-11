import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Recipe {
  final int id;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String thumbnail;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.thumbnail,
  });
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] as int,
      name: json['title'] as String,
      description: json['description'] as String,
      ingredients:
          (json['ingredients'] as List).map((item) => item as String).toList(),
      steps:
          (json['instruction'] as List).map((item) => item as String).toList(),
      thumbnail: json['thumbnail'] as String,
    );
  }
}
