import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../database/meal_database.dart';
import '../models/food_item.dart';

class MealRepository {
  final _db = MealDatabase.instance;

  Future<void> addToFavorites(FoodItem meal) async {
    final hasSpace = await _hasEnoughSpace();
    if (!hasSpace) {
      throw Exception("Not enough storage space to save favorite.");
    }
    await _db.insertMeal(meal);
  }

  Future<void> removeFromFavorites(String id) => _db.removeMeal(id);
  Future<List<FoodItem>> getFavorites() => _db.getAllFavorites();
  Future<bool> isFavorite(String id) => _db.isFavorite(id);
  Future<FoodItem?> getMealById(String id) => _db.getMealById(id);

  // Optional: You can tune the minimum required space here
  Future<bool> _hasEnoughSpace({int minBytes = 1024 * 1024}) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final stat = await FileStat.stat(dir.path);
      // ⚠ Flutter doesn't provide actual free space — simulate or use a native plugin
      return true; // Always true for now unless you integrate platform-specific code
    } catch (e) {
      return false; // If error, treat as not enough space
    }
  }
}
