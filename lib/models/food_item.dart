import 'dart:convert';

class FoodItem {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;
  final String youtubeUrl;
  final List<String> ingredients;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    required this.youtubeUrl,
    required this.ingredients,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient.toString().trim());
      }
    }

    return FoodItem(
      id: json['idMeal'] ?? 'Loading',
      name: json['strMeal'] ?? 'Loading',
      category: json['strCategory'] ?? 'Unknown',
      area: json['strArea'] ?? 'Unknown',
      instructions: json['strInstructions'] ?? 'No instructions available.',
      thumbnail: json['strMealThumb'] ??
          'https://media.istockphoto.com/id/1162577265/vector/loading-icon-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=s3AuEATjZppJS1haHJwdK3VdeBwzZw7VpYacstP4zKI=',
      youtubeUrl: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    List<String> ingredients = [];

    if (map['ingredients'] != null && map['ingredients'] is String) {
      try {
        final decoded = jsonDecode(map['ingredients']) as List<dynamic>;
        ingredients = decoded.map((e) => e.toString()).toList();
      } catch (_) {
        ingredients = map['ingredients'].toString().split(',');
      }
    }

    return FoodItem(
      id: map['id'] ?? 'Loading',
      name: map['name'] ?? 'Loading',
      category: map['category'] ?? 'Unknown',
      area: map['area'] ?? 'Unknown',
      instructions: map['instructions'] ?? 'No instructions available.',
      thumbnail: map['thumbnail'] ??
          'https://media.istockphoto.com/id/1162577265/vector/loading-icon-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=s3AuEATjZppJS1haHJwdK3VdeBwzZw7VpYacstP4zKI=',
      youtubeUrl: map['youtubeUrl'] ?? '',
      ingredients: ingredients,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'area': area,
      'instructions': instructions,
      'thumbnail': thumbnail,
      'youtubeUrl': youtubeUrl,
      'ingredients': jsonEncode(ingredients), 
    };
  }
}
