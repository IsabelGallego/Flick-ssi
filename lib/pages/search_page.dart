import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flickssi/constants/constants.dart';
import 'package:flickssi/controller/controller.dart';
import 'package:flickssi/api/api_constants.dart';
import 'package:flickssi/widgets/icon_widget.dart';
import 'package:flickssi/widgets/text1.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  MovieController movieController = Get.put(MovieController());
  String query = '';

  Widget getSearch() {
    return GetBuilder<MovieController>(builder: (controller) {
      if (movieController.searchedMovies.isEmpty) {
        return const Center(child: Text1(text: 'Busca una pelicula!'));
      } else {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.52,
          ),
          itemCount: movieController.searchedMovies.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                movieController.getDetail(
                  movieController.searchedMovies[index].id.toString(),
                );
                movieController.getCastList(
                  movieController.searchedMovies[index].id.toString(),
                );
                movieController.getSimilar(
                  movieController.searchedMovies[index].id.toString(),
                );
                Get.toNamed('/deatils');
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(
                      ApiConstants.baseImgUrl +
                          movieController.searchedMovies[index].posterPath
                              .toString(),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      }
    });
  }

  void showEmptyQuerySnackbar() {
    Get.snackbar(
      'Advertencia',
      'Por favor, ingresa el nombre de la película',
      backgroundColor: Colors.black,
      colorText: Colors.white,
    );
  }

  Future<void> refreshSearch() async {
    if (query.isNotEmpty) {
      movieController.getMovieSearch(query);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text1(
          text: 'Busca peliculas',
          fontSize: 22,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        query = value;
                      },
                      autofocus: true,
                      cursorColor:
                          Theme.of(context).primaryTextTheme.bodyLarge?.color,
                      decoration: InputDecoration(
                        hintText: 'Ingresa el nombre de la pelicula',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const IconWidget(
                      iconPath: MyIcons.search,
                    ),
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus &&
                          currentFocus.focusedChild != null) {
                        currentFocus.focusedChild?.unfocus();
                      }

                      if (query.isEmpty) {
                        showEmptyQuerySnackbar();
                      } else {
                        movieController.getMovieSearch(query);
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12.0, top: 20),
            child: Text1(text: 'Mejores resultados'),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshSearch,
              child: Container(
                margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
                height: double.maxFinite,
                child: getSearch(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
