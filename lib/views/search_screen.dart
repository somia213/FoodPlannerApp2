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

  bool _noConnection = false;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<SearchViewModel>(context, listen: false);
    _connectivity = Connectivity();
    _connectivityStream = _connectivity.onConnectivityChanged;

    _connectivityStream.listen((ConnectivityResult result) {
      setState(() {
        _noConnection = result == ConnectivityResult.none;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bool success = await viewModel.loadAllMeals();
      if (!success && mounted) {
        _showErrorDialog(viewModel.errorMessage ?? 'Something went wrong');
      }
    });

    viewModel.searchController.addListener(() {
      viewModel.searchFood();
    });
  }

  void _showErrorDialog(String message) {
    alert(
      context,
      title: const Text('Error'),
      content: Text(message),
      textOK: const Text('Retry'),
    ).then((_) {
      viewModel.loadAllMeals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SearchViewModel>(context);

    if (_noConnection) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF033D05),
          title: const Text(
            'No Connection',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/NoConnection.gif',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              const Text(
                'No Internet Connection',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final result = await _connectivity.checkConnectivity();
                  if (result != ConnectivityResult.none) {
                    setState(() => _noConnection = false);
                    viewModel.loadAllMeals();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF033D05),
                ),
                child: const Text('Retry' , style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search for your favourite food",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF033D05),
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
                prefixIcon: const Icon(Icons.fastfood),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  onPressed: viewModel.searchFood,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          if (viewModel.isLoading)
            const CircularProgressIndicator()
          else if (viewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                viewModel.errorMessage!,
                style: const TextStyle(
                  color: Color.fromARGB(255, 83, 14, 9),
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            )
          else if (viewModel.meals.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Search something else! 🍕'),
            )
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
                            mealId: item.id,
                            fromFavorites: false,
                          ),
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
