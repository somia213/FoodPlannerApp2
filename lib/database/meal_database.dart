import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:first_app/models/food_item.dart';

class MealDatabase {

  static final MealDatabase instance = MealDatabase._init();
  static Database? _database;
  MealDatabase._init();

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

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

  Future _createDB(Database db, int version) async {
    await db.execute('''
     CREATE TABLE favorites (
  id TEXT PRIMARY KEY,
  name TEXT,
  category TEXT,
  area TEXT,
  instructions TEXT,
  thumbnail TEXT,
  youtubeUrl TEXT,
  ingredients TEXT,
  localImagePath TEXT
)

     ''');
  }

  Future<void> insertMeal(FoodItem meal) async {
    final db = await instance.database;
    await db.insert(
        'favorites',
        {
          'id': meal.id,
          'name': meal.name,
          'category': meal.category,
          'area': meal.area,
          'instructions': meal.instructions,
          'thumbnail': meal.thumbnail,
          'youtubeUrl': meal.youtubeUrl,
          'ingredients': meal.ingredients.join(','),
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeMeal(String id) async {
    final db = await instance.database;
    db.delete('favorites', where: 'id = ?', whereArgs: [id]);
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
    final result =
        await db.query('favorites', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future<FoodItem?> getMealById(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return FoodItem.fromMap(maps.first);
    } else {
      return null;
    }
  }
}