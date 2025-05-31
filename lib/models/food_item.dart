
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
}
