import '../database/meal_database.dart';
import '../models/food_item.dart';

// middle level between database & viewmodel 
// Prevents the ViewModel from accessing the database directly and knowing how to write queries.

class MealRepository{
  final _db = MealDatabase.instance;

  Future<void> addToFavorites(FoodItem meal) => _db.insertMeal(meal);
  Future<void> removeFromFavorites(String id) => _db.removeMeal(id);
  Future<List<FoodItem>> getFavorites() => _db.getAllFavorites();
  Future<bool> isFavorite(String id) => _db.isFavorite(id);
  Future<FoodItem?> getMealById(String id) => _db.getMealById(id);
  
  }