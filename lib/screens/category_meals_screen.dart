import 'package:flutter/material.dart';
import 'meal_detail_screen.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../services/favorites_manager.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String categoryName;

  CategoryMealsScreen({required this.categoryName});

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  final ApiService _apiService = ApiService();
  List<Meal> _meals = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }
  
  void _loadMeals() async {
    try {
      final meals = await _apiService.fetchMealsByCategory(widget.categoryName);
      setState(() {
        _meals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }
  
  void _searchMeals() async {
    if(_searchController.text.isEmpty) {
      _loadMeals();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final meals = await _apiService.searchMeals(_searchController.text);
      setState(() {
        _meals = meals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search meals...',
                  prefixIcon: IconButton(
                      onPressed: _searchMeals, 
                      icon: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _searchMeals(),
              ),
          ),
          Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _meals.isEmpty
                    ? Center(child: Text("No meals found."))
                    : GridView.builder(
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3 / 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            ), 
                        itemCount: _meals.length,
                  itemBuilder: (context, index) {
                    final meal = _meals[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealDetailScreen(mealId: meal.id),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          GridTile(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(meal.thumbnail, fit: BoxFit.cover),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    meal.name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: ValueListenableBuilder<List<Meal>>(
                              valueListenable: FavoritesManager.instance.favorites,
                              builder: (context, favorites, _) {
                                final isFav = FavoritesManager.instance.isFavorite(meal.id);
                                return IconButton(
                                  icon: Icon(
                                    isFav ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    FavoritesManager.instance.toggleFavorite(meal);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
              ),
          ),
        ],
      ),
    );
  }
}