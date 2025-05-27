import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Root widget with MaterialApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Optional: remove debug banner
      title: 'First App',
      home: const HomeScreen(), // Main screen
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              // You can handle menu logic here
              print('Selected: $value');
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Sign Up"),
                value: "Up",
              ),
              PopupMenuItem(
                child: Text("Sign In"),
                value: "In",
              ),
              PopupMenuItem(
                child: Text("Sign Out"),
                value: "Out",
              ),
            ],
          ),
        ],
      ),
      body: Row(
        children: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomDelegate());
            },
          ),
        ],
      ),
    );
  }
}

// Custom Search Delegate
class CustomDelegate extends SearchDelegate {
  List names = ["Ahmed", "Mohammed", "Ali", "Shady", "Yasser"];
  List? filterName;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ""; // Clear search field
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // Close search
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Placeholder for search results
    return Center(child: Text("Results for: $query"));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      return ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(names[index]),
            ),
          );
        },
      );
    } else {
      filterName = names
          .where((element) =>
              element.toLowerCase().startsWith(query.toLowerCase()))
          .toList();

      return ListView.builder(
        itemCount: filterName!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              showResults(context);
            },
            child: Card(
              child: ListTile(
                title: Text(filterName![index]),
              ),
            ),
          );
        },
      );
    }
  }
}
