class FoodItem {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbnail;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbnail,
    
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['idMeal'] ?? 'Loading',
      name: json['strMeal'] ?? 'Loading',
      category: json['strCategory'] ?? 'Loading',
      area: json['strArea'] ?? 'Loading',
      instructions: json['strInstructions'] ?? 'Loading',
      thumbnail: json['strMealThumb'] ?? 'https://media.istockphoto.com/id/1162577265/vector/loading-icon-isolated-on-white-background.jpg?s=612x612&w=0&k=20&c=s3AuEATjZppJS1haHJwdK3VdeBwzZw7VpYacstP4zKI=',
    );
  }
}
