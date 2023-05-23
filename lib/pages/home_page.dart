import 'package:carousel_slider/carousel_slider.dart';
import 'package:flickssi/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flickssi/controller/controller.dart';
import 'package:flickssi/api/api_constants.dart';
import 'package:flickssi/widgets/circular_indicator.dart';
import 'package:flickssi/widgets/header_tile.dart';
import 'package:flickssi/widgets/horizontal_movie_card.dart';
import 'package:flickssi/widgets/vertical_movie_card.dart';
import 'package:flickssi/widgets/text_grande.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MovieController movieController = Get.put(MovieController());
  CarouselController _carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MovieController>(builder: (controller) {
        return ListView(
          children: [
            const HeaderTile(),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, bottom: 8),
              child: Text1(text: 'Peliculas disponibles'),
            ),
            movieController.popularMovies.isNotEmpty
                ? CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: ((movieController.popularMovies.length +
                                movieController.topratedMovies.length +
                                movieController.allMovies.length +
                                movieController.trendingMovies.length) *
                            2)
                        .toInt(),
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 1,
                      height: 200,
                      viewportFraction: 0.90,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      onPageChanged: (index, reason) {
                        if (index ==
                            ((movieController.popularMovies.length +
                              movieController.topratedMovies.length +
                              movieController.allMovies.length +
                              movieController.trendingMovies.length) * 2 -1))
                               {
                          _carouselController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                    ),
                    itemBuilder: (context, index, realIdx) {
                      final List<MovieModel> allMovies = [
                        ...movieController.popularMovies,
                        ...movieController.topratedMovies,
                        ...movieController.allMovies,
                        ...movieController.trendingMovies,
                        
                      ];

                      final movieIndex = index % allMovies.length;
                      final movie = allMovies[movieIndex];

                      return HorizontalMovieCard(
                        onTap: () {
                          setState(() {
                            movieController.getCastList(movie.id.toString());
                            movieController.getDetail(movie.id.toString());
                            movieController.getSimilar(movie.id.toString());
                            Get.toNamed('/deatils');
                          });
                        },
                        imgUrl: ApiConstants.baseImgUrl +
                            movie.backdropPath.toString(),
                        movieTitle: movie.originalTitle.toString(),
                      );
                    },
                  )
                : const CircleIndicator(height: 201, width: double.maxFinite),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, bottom: 8, top: 20),
              child: Text1(text: 'Populares'),
            ),
            SizedBox(
              height: 270,
              child: movieController.trendingMovies.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieController.trendingMovies.length,
                      itemBuilder: (context, index) {
                        return VerticalMovieCard(
                          onTap: () {
                            setState(() {
                              movieController.getCastList(movieController
                                  .trendingMovies[index].id
                                  .toString());
                              movieController.getDetail(movieController
                                  .trendingMovies[index].id
                                  .toString());
                              movieController.getSimilar(movieController
                                  .trendingMovies[index].id
                                  .toString());
                              Get.toNamed('/deatils');
                            });
                          },
                          imgUrl: ApiConstants.baseImgUrl +
                              movieController.trendingMovies[index].posterPath
                                  .toString(),
                        );
                      })
                  : const CircleIndicator(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, bottom: 8, top: 20),
              child: Text1(text: 'Mejores aclamadas por la crítica'),
            ),
            SizedBox(
              height: 270,
              child: movieController.topratedMovies.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieController.topratedMovies.length,
                      itemBuilder: (context, index) {
                        return VerticalMovieCard(
                          onTap: () {
                            setState(() {
                              movieController.getCastList(movieController
                                  .topratedMovies[index].id
                                  .toString());
                              movieController.getDetail(movieController
                                  .topratedMovies[index].id
                                  .toString());
                              movieController.getSimilar(movieController
                                  .topratedMovies[index].id
                                  .toString());
                              Get.toNamed('/deatils');
                            });
                          },
                          imgUrl: ApiConstants.baseImgUrl +
                              movieController.topratedMovies[index].posterPath
                                  .toString(),
                        );
                      })
                  : const CircleIndicator(),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, bottom: 8, top: 20),
              child: Text1(text: 'Populares del momento'),
            ),
            SizedBox(
              height: 270,
              child: movieController.popularMovies.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: movieController.popularMovies.length,
                      itemBuilder: (context, index) {
                        return VerticalMovieCard(
                          onTap: () {
                            setState(() {
                              movieController.getCastList(movieController
                                  .popularMovies[index].id
                                  .toString());
                              movieController.getDetail(movieController
                                  .popularMovies[index].id
                                  .toString());
                              movieController.getSimilar(movieController
                                  .popularMovies[index].id
                                  .toString());
                              Get.toNamed('/deatils');
                            });
                          },
                          imgUrl: ApiConstants.baseImgUrl +
                              movieController.popularMovies[index].posterPath
                                  .toString(),
                        );
                      })
                  : const CircleIndicator(),
            ),
          ],
        );
      }),
    );
  }
}
