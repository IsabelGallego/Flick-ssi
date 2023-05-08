import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flickssi/controller/controller.dart';
import 'package:flickssi/api/api_constants.dart';
import 'package:flickssi/widgets/circular_indicator.dart';
import 'package:flickssi/widgets/fav_card.dart';
import 'package:flickssi/widgets/text1.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  MovieController movieController = Get.put(MovieController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text1(
          text: 'Tus favoritos',
          fontSize: 22,
        ),
        automaticallyImplyLeading: false,
      ),
      body: GetBuilder<MovieController>(
        builder: (controller) {
          return movieController.trendingMovies.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListView.builder(
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return FavCard(
                          imgUrl: ApiConstants.baseImgUrl +
                              movieController.trendingMovies[index].posterPath
                                  .toString(),
                          title: movieController
                              .trendingMovies[index].originalTitle
                              .toString(),
                          overview: movieController
                              .trendingMovies[index].overview
                              .toString(),
                          rating: movieController
                              .trendingMovies[index].voteAverage!
                              .toStringAsFixed(1),
                          runtime: '125',
                          releaseDate: movieController
                              .trendingMovies[index].releaseDate
                              .toString(),
                        );
                      }),
                )
              : const CircleIndicator();
        },
      ),
    );
  }
}
