import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flickssi/constants/constants.dart';
import 'package:flickssi/controller/controller.dart';
import 'package:flickssi/api/api_constants.dart';
import 'package:flickssi/widgets/cast_card.dart';
import 'package:flickssi/widgets/circular_indicator.dart';
import 'package:flickssi/widgets/icon_widget.dart';
import 'package:flickssi/widgets/text1.dart';
import 'package:flickssi/widgets/text2.dart';
import 'package:flickssi/widgets/title_text.dart';
import 'package:flickssi/widgets/vertical_movie_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DetailsPage extends StatefulWidget {
  final String? movieId;

  const DetailsPage({this.movieId, Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  MovieController movieController = Get.put(MovieController());
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Obtener el estado de favoritos del usuario en función de la película actual
    checkIfFavorite();
    print(isFavorite);
  }

  void checkIfFavorite() {
    // Obtén el usuario actual autenticado mediante Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Obtiene la referencia al documento del usuario actual en Firestore
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      userRef.get().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic>? userData =
              snapshot.data() as Map<String, dynamic>?;

          List<String>? favoriteMovies =
              userData?['favoriteMovies']?.cast<String>();
          if (favoriteMovies != null &&
              favoriteMovies.contains(widget.movieId)) {
            setState(() {
              isFavorite = true;
            });
          }
        }
      }).catchError((error) {
        // Ocurrió un error al obtener el documento del usuario
        print('Error al obtener el documento del usuario: $error');
      });
    }
  }

  void addToFavorites(String movieId) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      userRef.get().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic>? userData =
              snapshot.data() as Map<String, dynamic>?;

          List<String>? favoriteMovies =
              userData?['favoriteMovies']?.cast<String>();
          if (favoriteMovies == null) {
            favoriteMovies = [movieId];
          } else {
            favoriteMovies.add(movieId);
          }

          userRef.update({
            'favoriteMovies': favoriteMovies,
          }).then((value) {
            setState(() {
              isFavorite = true; // Actualizar el estado local
            });
            print('Película agregada a favoritos del usuario');
          }).catchError((error) {
            // Ocurrió un error al actualizar la lista de favoritos del usuario
            print(
                'Error al actualizar la lista de favoritos del usuario: $error');
          });
        } else {
          // El documento del usuario no existe, realiza la acción adecuada en este caso
          userRef.set({
            'favoriteMovies': [movieId],
          }).then((value) {
            setState(() {
              isFavorite = true; // Actualizar el estado local
            });
            print(
                'Se creó un nuevo documento para el usuario con la película agregada a favoritos');
          }).catchError((error) {
            // Ocurrió un error al crear el documento del usuario
            print('Error al crear el documento del usuario: $error');
          });
        }
      }).catchError((error) {
        // Ocurrió un error al obtener el documento del usuario
        print('Error al obtener el documento del usuario: $error');
      });
    } else {
      // El usuario no está autenticado, realiza la acción adecuada en este caso
      print('El usuario no está autenticado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GetBuilder<MovieController>(builder: (controller) {
        return ListView(
          children: [
            Container(
              height: 600,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                image: DecorationImage(
                  image: NetworkImage(
                    ApiConstants.baseImgUrl +
                        movieController.movies.value.posterPath.toString(),
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 30,
                      left: 12,
                      right: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 270,
                                child: TitleText(
                                  title: movieController
                                      .movies.value.originalTitle
                                      .toString(),
                                ),
                              ),

                              // Favoritos
                              Row(
                                children: [
                                  IconWidget(iconPath: MyIcons.share),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      addToFavorites(
                                          movieController.movies.value.id!);
                                    },
                                    child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite ? Colors.red : null),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: MyColors.kAccentColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                  child: Text(
                                    'Calificación  ${movieController.movies.value.voteAverage?.toStringAsFixed(1)}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 1),
                              const IconWidget(
                                  iconPath: MyIcons.time, iconSize: 20),
                              Text2(
                                text:
                                    ' ${movieController.movies.value.runtime.toString()} min',
                                fontSize: 16,
                              ),
                              const SizedBox(width: 1),
                              const IconWidget(
                                  iconPath: MyIcons.calendar, iconSize: 20),
                              Text2(
                                text:
                                    ' ${movieController.movies.value.releaseDate.toString()}',
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, bottom: 8),
              child: Text1(text: 'Resumen'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 20),
              child: Text2(
                text: movieController.movies.value.overview.toString(),
                maxLines: 5,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, bottom: 8),
              child: Text1(text: 'Reparto'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              height: 210,
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: movieController.movieCast.length <= 10
                      ? movieController.movieCast.length
                      : 10,
                  itemBuilder: (context, index) {
                    return movieController.movieCast.isNotEmpty
                        ? CastCard(
                            imgUrl: ApiConstants.baseImgUrl +
                                movieController.movieCast[index].profilePath
                                    .toString(),
                            castName: movieController.movieCast[index].name
                                .toString(),
                            character: movieController
                                .movieCast[index].character
                                .toString(),
                          )
                        : const CircleIndicator();
                  }),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, bottom: 8, top: 20),
              child: Text1(text: 'Películas similares'),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              height: 180,
              color: Theme.of(context).appBarTheme.backgroundColor,
              child: movieController.similarMovies.isNotEmpty
                  ? ListView.builder(
                      itemCount: movieController.similarMovies.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return VerticalMovieCard(
                          imgUrl: ApiConstants.baseImgUrl +
                              movieController.similarMovies[index].posterPath
                                  .toString(),
                          onTap: () {
                            setState(() {
                              movieController.getDetail(movieController
                                  .similarMovies[index].id
                                  .toString());
                              movieController.getCastList(movieController
                                  .similarMovies[index].id
                                  .toString());
                              movieController.getSimilar(movieController
                                  .similarMovies[index].id
                                  .toString());
                              Get.toNamed('/deatils');
                            });
                          },
                          width: 95,
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
