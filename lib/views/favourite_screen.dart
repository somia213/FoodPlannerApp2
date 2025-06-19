import 'package:first_app/views/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/favorite_viewmodel.dart';
import '../widgets/food_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late MealViewModel mealViewModel;

  @override
  void initState() {
    super.initState();
    mealViewModel = Provider.of<MealViewModel>(context, listen: false);
    mealViewModel.loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealViewModel>(
      builder: (context, vm, _) {
        final favorites = vm.favorites;

        return Scaffold(
          appBar: AppBar(
             iconTheme: const IconThemeData(color: Colors.white),
            title: const Text('Your Favorites' , style: TextStyle(color: Colors.white),),
            backgroundColor: Color(0xFF033D05),
          ),
          body: favorites.isEmpty
              ? const Center(child: Text("No favorites yet! 💔"))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final meal = favorites[index];
                    return FoodCard(
                      food: meal,
                      onTap: () {
                        Navigator.push(
                          context,
                         MaterialPageRoute(builder: (_) => DetailsScreen(mealId: meal.id, fromFavorites: true)),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}