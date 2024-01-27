class TypeFilter {
  final String name;
  final String value;

  TypeFilter(this.name, this.value);
}

class TypeFilterStorage {
  static final List<TypeFilter> filters = [
    TypeFilter('Occasion', 'occasion'),
    TypeFilter('Healthy', 'healthy'),
    TypeFilter('Appetizers', 'appetizers'),
    TypeFilter('Main', 'main dish'),
    TypeFilter('Side dishes', 'side dishes'),
    TypeFilter('Vegetables', 'vegetables'),
    TypeFilter('Low cholesterol', 'low cholesterol'),
    TypeFilter('Low sodium', 'low sodium'),
    TypeFilter('Desserts', 'desserts'),
    TypeFilter('Low fat', 'low fat'),
    TypeFilter('Chicken', 'chicken'),
    TypeFilter('Asian', 'asian'),
    TypeFilter('Italian', 'italian'),
    TypeFilter('Easy', 'easy'),
    TypeFilter('Inexpensive', 'inexpensive'),
    TypeFilter('Oven', 'oven'),
  ];
}
