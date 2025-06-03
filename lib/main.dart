import 'package:first_app/views/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/favorite_viewmodel.dart';
import 'views/details_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => MealViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'First App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SplashView(),
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final mealId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => DetailsScreen(mealId: mealId),
          );
        }
        return null;
      },
    );
  }
}
