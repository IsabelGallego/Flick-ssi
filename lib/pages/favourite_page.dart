import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flickssi/controller/controller.dart';
import 'package:flickssi/api/api_constants.dart';
import 'package:flickssi/widgets/circular_indicator.dart';
import 'package:flickssi/widgets/fav_card.dart';
import 'package:flickssi/widgets/text_grande.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class FirestoreService {
  static Future<List<String>> getFavoriteMovies() async {
    List<String> favoriteMovies = [];

    // Obtén el usuario actual autenticado mediante Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Obtiene la referencia al documento del usuario actual en Firestore
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Obtiene el documento del usuario
      DocumentSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        Map<String, dynamic>? userData =
            snapshot.data() as Map<String, dynamic>?;

        // Obtén la lista de películas favoritas del usuario
        List<dynamic>? favoriteMoviesData = userData?['favoriteMovies'];

        if (favoriteMoviesData != null) {
          favoriteMovies = favoriteMoviesData.cast<String>().toList();
        }
      }
    }

    return favoriteMovies;
  }
}

class _FavouritesPageState extends State<FavouritesPage> {
  MovieController movieController = Get.put(MovieController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: FirestoreService.getFavoriteMovies(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final dynamic favoriteMovies = snapshot.data!;
          final List<dynamic> consultedfavorites = [];

          return Scaffold(
            appBar: AppBar(
              title: const Text1(
                text: 'Tus favoritos',
                fontSize: 22,
              ),
              automaticallyImplyLeading: false,
            ),
            body: FutureBuilder<List<dynamic>>(
              future: Future.wait(
                favoriteMovies.map(
                    (String movie) => movieController.searchedFavorite(movie)),
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> favSnapshot) {
                if (favSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircleIndicator();
                } else if (favSnapshot.hasError) {
                  return Center(child: Text('Error: ${favSnapshot.error}'));
                } else {
                  consultedfavorites.addAll(favSnapshot.data!);

                  return consultedfavorites.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListView.builder(
                            itemCount: consultedfavorites.length,
                            itemBuilder: (context, index) {
                              return FavCard(
                                imgUrl: ApiConstants.baseImgUrl +
                                    consultedfavorites[index]
                                        .posterPath
                                        .toString(),
                                title: consultedfavorites[index]
                                    .originalTitle
                                    .toString(),
                                overview: consultedfavorites[index]
                                    .overview
                                    .toString(),
                                rating: consultedfavorites[index]
                                    .voteAverage!
                                    .toStringAsFixed(1),
                                runtime: '125',
                                releaseDate: consultedfavorites[index]
                                    .releaseDate
                                    .toString(),
                              );
                            },
                          ),
                        )
                      : const CircleIndicator();
                }
              },
            ),
          );
        }
      },
    );
  }
}
