import 'package:flutter/foundation.dart';
import '../models/meal.dart';

class FavoritesManager {
  FavoritesManager._();
  static final FavoritesManager instance = FavoritesManager._();

  final ValueNotifier<List<Meal>> favorites = ValueNotifier<List<Meal>>([]);

  bool isFavorite(String mealId) {
    return favorites.value.any((m) => m.id == mealId);
  }

  void toggleFavorite(Meal meal) {
    final current = List<Meal>.from(favorites.value);
    final index = current.indexWhere((m) => m.id == meal.id);

    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(meal);
    }

    favorites.value = current;
  }
}