import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../repository/meal_repository.dart';

class MealViewModel extends ChangeNotifier {
  final _repo = MealRepository();
  List<FoodItem> _favorites = [];
  List<FoodItem> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await _repo.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(FoodItem meal) async {
    final isFav = await _repo.isFavorite(meal.id);
    if (isFav) {
      await _repo.removeFromFavorites(meal.id);
    } else {
      await _repo.addToFavorites(meal);
    }
    await loadFavorites();
  }

  Future<bool> isFavorite(String id) async {
    return await _repo.isFavorite(id);
  }
}
