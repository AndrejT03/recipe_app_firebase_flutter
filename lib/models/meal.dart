class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final String? instructions;
  final String? youtubeUrl;
  final List<String> ingredients;
  final List<String> measures;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.instructions,
    this.youtubeUrl,
    this.ingredients = const [],
    this.measures = const [],
  });

  factory Meal.fromSimpleJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
    );
  }

  factory Meal.fromDetailJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.toString().isNotEmpty) {
        ingredients.add(ingredient);
        measures.add(measure ?? '');
      }
    }

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      instructions: json['strInstructions'],
      youtubeUrl: json['strYoutube'],
      ingredients: ingredients,
      measures: measures,
    );
  }
}