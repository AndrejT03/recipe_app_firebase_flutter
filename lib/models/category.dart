class MealCategory {
  final String id;
  final String name;
  final String thumbnail;
  final String description;

  MealCategory({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  MealCategory.fromJson(Map<String, dynamic> data)
      : id = data['idCategory'],
        name = data['strCategory'],
        thumbnail = data['strCategoryThumb'],
        description = data['strCategoryDescription'];

  Map<String, dynamic> toJson() => {
    'idCategory': id,
    'strCategory': name,
    'strCategoryThumb': thumbnail,
    'strCategoryDescription': description,
  };
}