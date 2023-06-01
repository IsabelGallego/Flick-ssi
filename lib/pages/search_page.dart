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
  TextEditingController searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void refreshPage() {
    setState(() {
      movieController.searchedMovies.clear();
      searchController.clear();
    });
  }

  void showSnackbar(String message) {
    Get.snackbar(
      'No fue posible realizar la búsqueda',
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black,
      colorText: Colors.white,
      borderRadius: 0,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
  }

  Widget getSearch() {
    return GetBuilder<MovieController>(builder: (controller) {
      return movieController.searchedMovies.isNotEmpty
          ? GridView.builder(
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
                        movieController.searchedMovies[index].id.toString());
                    movieController.getCastList(
                        movieController.searchedMovies[index].id.toString());
                    movieController.getSimilar(
                        movieController.searchedMovies[index].id.toString());
                    Get.toNamed('/details');
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
            )
          : const Center(child: Text1(text: 'Busca una pelicula!'));
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
      body: RefreshIndicator(
        onRefresh: () async {
          refreshPage();
          return Future.delayed(const Duration(milliseconds: 500));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      key: formKey,
                      onChanged: (value) {},
                      autofocus: movieController.searchedMovies.isEmpty,
                      cursorColor:
                          Theme.of(context).primaryTextTheme.bodyLarge?.color,
                      decoration: InputDecoration(
                        hintText: 'Ingresa el nombre de la pelicula',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const IconWidget(iconPath: MyIcons.search),
                    onPressed: () {
                      final query = searchController.text.trim();
                      if (query.isEmpty) {
                        showSnackbar('El cuadro de búsqueda está vacío');
                      } else {
                        FocusScope.of(context).unfocus();
                        movieController.getMovieSearch(query);
                      }
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 12.0, top: 20),
              child: Text1(text: 'Mejores resultados'),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
                height: double.maxFinite,
                child: getSearch(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
