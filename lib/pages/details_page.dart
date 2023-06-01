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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final String? movieId;
  final Map<String, dynamic> movie;

  const DetailsPage({
    this.movieId,
    required this.movie,
    Key? key,
  }) : super(key: key);

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
          Map<dynamic, dynamic>? userData =
              snapshot.data() as Map<dynamic, dynamic>?;

          Map<dynamic, dynamic>? favoriteMovies =
              userData?['favoriteMovies'] as Map<dynamic, dynamic>?;

          if (favoriteMovies != null) {
            if (favoriteMovies.containsKey(widget.movieId)) {
              setState(() {
                isFavorite = true;
              });
            } else {
              setState(() {
                isFavorite = false;
              });
            }
          }
        }
      }).catchError((error) {
        // Ocurrió un error al obtener el documento del usuario
        print('Error al obtener el documento del usuario: $error');
      });
    }
  }

  void addToFavorites(Map<dynamic, Object?> movieId) {
    print(movieId);

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      userRef.get().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<dynamic, dynamic>? userData =
              snapshot.data() as Map<dynamic, dynamic>?;

          List<Map<dynamic, Object?>>? favoriteMovies =
              userData?['favoriteMovies']?.cast<Map<dynamic, Object?>>();

          if (favoriteMovies == null) {
            favoriteMovies = [movieId];
          } else {
            var index = favoriteMovies.length;
            favoriteMovies
                .removeWhere((movie) => movie['movieID'] == movieId['movieID']);
            var index2 = favoriteMovies.length;
            if (index == index2) {
              favoriteMovies.add(movieId);
              
            }
          }

          userRef.update({
            'favoriteMovies': favoriteMovies,
          }).then((value) {
            setState(() {
              isFavorite = favoriteMovies?.contains(movieId) ?? false;
            });
            if (isFavorite) {
              showSnackBar('Película agregada a favoritos');
              print('Película agregada a favoritos del usuario');
            } else {
              showSnackBar('Película eliminada de favoritos');
              print('Película eliminada de favoritos del usuario');
            }
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
              isFavorite = false; // Actualizar el estado local
            });
            showSnackBar(
                'Se creó un nuevo documento para el usuario con la película agregada a favoritos');
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

  void removeFromFavorites(Map<String, Object?> movieId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar la película de tus favoritos?'),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteFromFavorites(movieId);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void deleteFromFavorites(Map<String, Object?> movieId) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      userRef.get().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic>? userData =
              snapshot.data() as Map<String, dynamic>?;

          List<Map<String, Object?>>? favoriteMovies =
              userData?['favoriteMovies']?.cast<Map<String, Object?>>();

          if (favoriteMovies != null) {
            favoriteMovies
                .removeWhere((movie) => movie['movieID'] == movieId['movieID']);

            userRef.update({
              'favoriteMovies': favoriteMovies,
            }).then((value) {
              setState(() {
                isFavorite = favoriteMovies.contains(movieId);
              });
              showSnackBar('Película eliminada de favoritos');
              print('Película eliminada de favoritos del usuario');
            }).catchError((error) {
              // Ocurrió un error al actualizar la lista de favoritos del usuario
              print(
                  'Error al actualizar la lista de favoritos del usuario: $error');
            });
          }
        }
      }).catchError((error) {
        // Ocurrió un error al obtener el documento del usuario
        print('Error al obtener el documento del usuario: $error');
      });
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
                                  GestureDetector(
                                    onTap: () {
                                      var obj = {
                                        'posterPath': movieController
                                            .movies.value.posterPath,
                                        'originalTitle': movieController
                                            .movies.value.originalTitle,
                                        'overview': movieController
                                            .movies.value.overview,
                                        'voteAverage': movieController
                                            .movies.value.voteAverage,
                                        'releaseDate': movieController
                                            .movies.value.releaseDate,
                                        'movieID':
                                            movieController.movies.value.id
                                      };
                                      if (isFavorite) {
                                        removeFromFavorites(obj);
                                      } else {
                                        addToFavorites(obj);
                                      }
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
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: TitleText(title: 'Sinopsis'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text1(
                text: movieController.movies.value.overview.toString(),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
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
