import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class MealDetailsViewModel extends ChangeNotifier {
  FoodItem? meal;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadMealDetails(String mealId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      final url = Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic>? mealsJson = data['meals'];

        if (mealsJson == null || mealsJson.isEmpty) {
          meal = null;
          errorMessage = "Meal not found.";
        } else {
          meal = FoodItem.fromJson(mealsJson[0]);
        }
      } else {
        errorMessage = 'Error: ${response.statusCode}';
        meal = null;
      }
    } catch (e) {
      errorMessage = 'Failed to load meal details. ${e.toString()}';
      meal = null;
    }

    isLoading = false;
    notifyListeners();
  }
}
