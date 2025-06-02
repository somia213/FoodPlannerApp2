import 'package:first_app/viewmodels/search_viewmodel.dart';
import 'package:first_app/views/details_screen.dart';
import 'package:first_app/widgets/food_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<SearchViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.loadAllMeals();
    });

    viewModel.searchController.addListener(() {
      viewModel.searchFood();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Search for your favourite food"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: viewModel.searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Enter food name .....",
                prefixIcon: Icon(Icons.fastfood),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                    onPressed: () {
                      viewModel.searchFood();
                    },
                    icon: Icon(Icons.search)),
              ),
            ),
          ),
          if (viewModel.isLoading)
            const CircularProgressIndicator()
          else if (viewModel.errorMessage != null)
            Text(
              viewModel.errorMessage!,
              style: const TextStyle(color: Colors.red),
            )
          else if (viewModel.meals.isEmpty)
            const Text('Search something else! 🍕')
          else
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.meals.length,
                itemBuilder: (context, index) {
                  final item = viewModel.meals[index];
                  return FoodCard(
                    food: item,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(mealId: item.id, fromFavorites: false),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}