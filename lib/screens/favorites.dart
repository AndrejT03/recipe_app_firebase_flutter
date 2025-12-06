import 'package:flutter/material.dart';
import '../services/favorites_manager.dart';
import '../models/meal.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite recipes')),
      body: ValueListenableBuilder<List<Meal>>(
        valueListenable: FavoritesManager.instance.favorites,
        builder: (context, favorites, _) {
          if (favorites.isEmpty) {
            return Center(child: Text('No favorite recipes yet.'));
          }

          return GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final meal = favorites[index];

              return Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailScreen(mealId: meal.id),
                        ),
                      );
                    },
                    child: GridTile(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                meal.thumbnail,
                                fit: BoxFit.cover,
                              ),
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
                  ),

                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.blue),
                        onPressed: () {
                          FavoritesManager.instance.toggleFavorite(meal);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${meal.name} removed from favorites."),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}