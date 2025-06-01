import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:first_app/models/food_item.dart';

class MealDatabase {
// One shared instance of MealDatabase is used across the entire app.
// A private constructor stops other classes from creating new objects.
// Use .instance to open, update, or delete — no need to create again.

  static final MealDatabase instance = MealDatabase._init();
// instance is like the controller or manager — it gives you access to the database and controls when to open or close it.
// _database is the actual database connection that handles the real work like inserting, updating, deleting, and querying data.

  static Database? _database;
  MealDatabase._init();

//  file_path -> database file name
  Future<Database> _initDB(String file_path) async {
    final db_path = await getDatabasesPath();
    final path = join(db_path, file_path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('meals.db');
    return _database!;
  }

  Future _createDB(Database db , int version ) async {
    await db.execute(''' 
     CREATE TABLE favorites (
        id TEXT PRIMARY KEY,
        name TEXT,
        category TEXT,
        area TEXT,
        instructions TEXT,
        thumbnail TEXT,
        youtubeUrl TEXT,
        ingredients TEXT
      )
     ''');
  }

  Future<void> insertMeal(FoodItem meal) async{
    final db = await instance.database;
    await db.insert('favorites', {
      'id':meal.id,
       'name': meal.name,
        'category': meal.category,
        'area': meal.area,
        'instructions': meal.instructions,
        'thumbnail': meal.thumbnail,
        'youtubeUrl': meal.youtubeUrl,
        'ingredients': meal.ingredients.join(','),
    },
       conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> removeMeal(String id) async{
    final db = await instance.database;
    db.delete('favorites' , where: 'id = ?' , whereArgs: [id]);
  }

  Future<List<FoodItem>> getAllFavorites() async {
    final db = await instance.database;
    final result = await db.query('favorites');
    return result.map((json) {
      final ingredients = (json['ingredients'] as String).split(',');
      return FoodItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        area: json['area'] as String,
        instructions: json['instructions'] as String,
        thumbnail: json['thumbnail'] as String,
        youtubeUrl: json['youtubeUrl'] as String,
        ingredients: ingredients,
      );
    }).toList();
  }

   Future<bool> isFavorite(String id) async {
    final db = await instance.database;
    final result = await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}

