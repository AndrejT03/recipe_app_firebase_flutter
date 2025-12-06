import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<MealCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['categories'] as List)
          .map((json) => MealCategory.fromJson(json))
          .toList();
    }
    throw Exception('Failed to load categories');
  }

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List)
          .map((json) => Meal.fromSimpleJson(json))
          .toList();
    }
    throw Exception('Failed to load meals');
  }

  Future<Meal> fetchMealDetails(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meal.fromDetailJson(data['meals'][0]);
    }
    throw Exception('Failed to load meal details');
  }

  Future<List<Meal>> searchMeals(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List)
          .map((json) => Meal.fromSimpleJson(json))
          .toList();
    }
    throw Exception('Failed to search meals');
  }

  Future<Meal> fetchRandomMeal() async {
    final response = await http.get(Uri.parse('$_baseUrl/random.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meal.fromDetailJson(data['meals'][0]);
    }
    throw Exception('Failed to load random meal');
  }
}