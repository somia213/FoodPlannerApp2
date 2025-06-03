import 'package:first_app/viewmodels/search_viewmodel.dart';
import 'package:first_app/views/details_screen.dart';
import 'package:first_app/widgets/food_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:alert_dialog/alert_dialog.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchViewModel viewModel;

  late final Connectivity _connectivity;
  late final Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<SearchViewModel>(context, listen: false);
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;

    _connectivityStream.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showNoConnectionDialog();
      }
    });

    void showErrorDialog(String message) {
      alert(
        context,
        title: const Text('Error'),
        content: Text(message),
        textOK: const Text('Retry'),
      ).then((_) {
        viewModel.loadAllMeals();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool success = await viewModel.loadAllMeals();
      if (!success && mounted) {
        showErrorDialog(viewModel.errorMessage ?? 'Something went wrong');
      }
    });

    viewModel.searchController.addListener(() {
      viewModel.searchFood();
    });
  }

  void _showNoConnectionDialog() {
    alert(
      context,
      title: const Text('No Internet'),
      content: const Text('Please check your connection and try again.'),
      textOK: const Text('Retry'),
    );
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
                          builder: (_) => DetailsScreen(
                              mealId: item.id, fromFavorites: false),
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
