import '../database/meal_database.dart';
import '../models/food_item.dart';

class MealRepository{
  final _db = MealDatabase.instance;

  Future<void> addToFavorites(FoodItem meal) => _db.insertMeal(meal);
  Future<void> removeFromFavorites(String id) => _db.removeMeal(id);
  Future<List<FoodItem>> getFavorites() => _db.getAllFavorites();
  Future<bool> isFavorite(String id) => _db.isFavorite(id);
  Future<FoodItem?> getMealById(String id) => _db.getMealById(id);
  
  }