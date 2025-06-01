import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  List<FoodItem> meals = [];

  List<FoodItem> _allMeals = [];

  Future<void> loadAllMeals() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final url =
          Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic>? mealsJson = data['meals'];

        if (mealsJson == null) {
          _allMeals = [];
          meals = [];
          errorMessage = "No meals found.";
        } else {
          _allMeals = mealsJson.map((json) => FoodItem.fromJson(json)).toList();
          meals = List.from(_allMeals);
        }
      } else {
        errorMessage = 'Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Failed to load data. ${e.toString()}';
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> searchFood() async {
    final searchItem = searchController.text.trim().toLowerCase();

    if (searchItem.isEmpty) {
      meals = List.from(_allMeals);
      errorMessage = null;
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    meals = _allMeals
        .where((meal) => meal.name.toLowerCase().startsWith(searchItem))
        .toList();

    if (meals.isEmpty) {
      errorMessage = "No meals found.";
    }

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
