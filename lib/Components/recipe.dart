class Recipe {
  late int id;
  late String name;
  late String description;
  late List<String> ingredients;
  late List<String> steps;
  late String thumbnail;
  late double totalCal;
  late int timeSpend;
  late int numOfServings;
  late List<String> likes;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.thumbnail,
    this.totalCal = 0,
    this.timeSpend = 0,
    this.numOfServings = 0,
    this.likes = const [],
  });

  Recipe.fromJsonPost(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'] as String;
    description = json['description'] as String;
    ingredients = (json['ingredients'] as List?)
            ?.map((item) => item as String)
            .toList() ??
        [];
    steps =
        (json['steps'] as List?)?.map((item) => item as String).toList() ?? [];
    thumbnail = json['thumbnail'] as String;
    totalCal = json['totalCal'] as double;
    timeSpend = json['timeSpend'] as int;
    numOfServings = json['numOfServings'] as int;
    likes =
        (json['likes'] as List?)?.map((item) => item as String).toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'steps': steps,
      'thumbnail': thumbnail,
      'totalCal': totalCal,
      'timeSpend': timeSpend,
      'numOfServings': numOfServings,
      'likes': likes,
    };
  }

  Recipe.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'] as String;
    description = json['description'] as String;
    ingredients = (json['ingredients_raw_str'] as List?)
            ?.map((item) => item as String)
            .toList() ??
        [];
    steps =
        (json['steps'] as List?)?.map((item) => item as String).toList() ?? [];
    thumbnail =
        json.containsKey('thumbnail') ? json['thumbnail'] as String? ?? '' : '';
    totalCal = double.tryParse(json['totalCal'].toString()) ?? 0.0;
    timeSpend = json.containsKey('timeSpend')
        ? int.parse(json['timeSpend'].toString())
        : 0;
    numOfServings = int.parse(json['servings'].toString());
    likes =
        (json['likes'] as List?)?.map((item) => item as String).toList() ?? [];
  }
}
