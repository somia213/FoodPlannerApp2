import 'package:alert_dialog/alert_dialog.dart';
import 'package:first_app/viewmodels/details_viewmodel.dart';
import 'package:first_app/viewmodels/favorite_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailsScreen extends StatefulWidget {
  final String mealId;
  final bool fromFavorites;

  const DetailsScreen(
      {super.key, required this.mealId, this.fromFavorites = false});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool showVideo = false;
  bool videoError = false;
  YoutubePlayerController? _controller;
  late MealDetailsViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = MealDetailsViewModel();

    viewModel
        .loadMealDetails(widget.mealId, fromFavorites: widget.fromFavorites)
        .then((_) {
      final videoId =
          YoutubePlayer.convertUrlToId(viewModel.meal?.youtubeUrl ?? '');
      if (videoId != null && videoId.isNotEmpty) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        )..addListener(() {
            if (_controller!.value.hasError) {
              setState(() {
                videoError = true;
              });
            }
          });
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget buildVideoSection() {
    if (videoError) {
      return const SizedBox(
        height: 200,
        child: Center(
            child: Text(
          'Video cannot be played',
          style: TextStyle(color: Colors.red),
        )),
      );
    }

    if (_controller == null) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No video available')),
      );
    }

    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MealDetailsViewModel>.value(
      value: viewModel,
      child: Consumer<MealDetailsViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (vm.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              alert(
                context,
                title: const Text('Error'),
                content: Text(vm.errorMessage!),
                textOK: const Text('Back'),
              ).then((_) {
                // ignore: use_build_context_synchronously
                Navigator.pop(context); 
              });
            });

            return const Scaffold(
              body: Center(
                  child:
                      CircularProgressIndicator()), 
            );
          }

          final meal = vm.meal!;

          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(meal.name , style: TextStyle(color: Colors.white),),
              backgroundColor: Color(0xFF033D05),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shadowColor: Colors.grey,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        meal.thumbnail,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/loading.jpg',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      FutureBuilder<bool>(
                        future: Provider.of<MealViewModel>(context)
                            .isFavorite(meal.id),
                        builder: (context, snapshot) {
                          final isFav = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Provider.of<MealViewModel>(context, listen: false)
                                  .toggleFavorite(meal);
                              setState(() {}); 
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text("Category: ${meal.category}",
                      style: const TextStyle(fontSize: 16)),
                  Text("Area: ${meal.area}",
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),

                  const Text(
                    "Instructions:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(meal.instructions, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),

                  const Text(
                    "Ingredients:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ...meal.ingredients.map((ingredient) => Text("- $ingredient",
                      style: const TextStyle(fontSize: 16))), 
                  const SizedBox(height: 24),

                  Text(
                    "Watch ${meal.name} video:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),

                  showVideo
                      ? buildVideoSection()
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              showVideo = true;
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/watch-now.webp',
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Icon(Icons.play_circle_fill,
                                  size: 64, color: Colors.white),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
