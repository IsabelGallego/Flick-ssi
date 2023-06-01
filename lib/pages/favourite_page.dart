import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flickssi/controller/controller.dart';
import 'package:flickssi/api/api_constants.dart';
import 'package:flickssi/widgets/circular_indicator.dart';
import 'package:flickssi/widgets/fav_card.dart';
import 'package:flickssi/widgets/text1.dart';

import '../services/firebase_service.dart';
import 'details_page.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

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
      body: FutureBuilder<dynamic>(
        future: FirebaseService.getUserFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mientras se espera la respuesta de la función getUserFavorites(), mostrar un indicador de carga
            return const CircleIndicator();
          } else if (snapshot.hasError) {
            // Si ocurre un error, mostrar un mensaje de error
            return const Text('Error al obtener los favoritos');
          } else if (snapshot.data == null) {
            // Si no hay datos disponibles, mostrar un mensaje indicando que no hay favoritos
            return const Text('No tienes favoritos');
          } else {
            // Si se obtienen datos correctamente, mostrar los favoritos en una lista
            List<Map<String, dynamic>> favoriteMovies =
                List<Map<String, dynamic>>.from(
                    snapshot.data['favoriteMovies']);
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: favoriteMovies.length,
                itemBuilder: (context, index) {
                  var movie = favoriteMovies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(movie: movie),
                        ),
                      );
                    },
                    child: FavCard(
                      imgUrl: ApiConstants.baseImgUrl +
                          movie['posterPath'].toString(),
                      title: movie['originalTitle'].toString(),
                      overview: movie['overview'].toString(),
                      rating: movie['voteAverage']!.toStringAsFixed(1),
                      runtime: '125',
                      releaseDate: movie['releaseDate'].toString(),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
