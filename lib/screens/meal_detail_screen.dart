import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';

class MealDetailScreen extends StatelessWidget {
  final String mealId;
  final ApiService _apiService = ApiService();

  MealDetailScreen({required this.mealId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Details')),
      body: FutureBuilder<Meal>(
        future: _apiService.fetchMealDetails(mealId),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if(snapshot.hasError) {
            return Center(child: Text('Error loading recipe.'));
          }

          final meal = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  meal.thumbnail,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text("Ingredients:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      ...List.generate(meal.ingredients.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.5),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                              SizedBox(width: 5),
                              Text("${meal.ingredients[index]} - ${meal.measures[index]}"),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 20),
                      Text("Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      ..._buildNumberedInstructions(meal.instructions),
                      if(meal.youtubeUrl != null && meal.youtubeUrl!.isNotEmpty) ...[
                        SizedBox(height: 20),
                        Text("Watch the full video guide on YouTube:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(meal.youtubeUrl!, style: TextStyle(color: Colors.blue)),
                        SizedBox(height: 20),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  List<Widget> _buildNumberedInstructions(String? instructions) {
    if(instructions == null || instructions.trim().isEmpty) {
      return [Text("No instructions available.")];
    }
    
    final steps = instructions.split(RegExp(r'(?<=[.!?])\s+'));
    return List<Widget>.generate(steps.length, (index) {
      final stepNum = index + 1;
      final stepText = steps[index].trim();
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$stepNum.  ", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(stepText)),
            ],
          ),
      );
    });
  }
}