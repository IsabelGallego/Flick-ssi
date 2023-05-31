import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flickssi/api/api_client.dart';
import 'package:flickssi/models/cast_model.dart';
import 'package:flickssi/models/movie_detail_model.dart';
import 'package:flickssi/models/movie_model.dart';

import '../services/firebase_service.dart';

class MovieController extends GetxController {
  ApiClient apiClient = ApiClient();

  List<MovieModel> trendingMovies = <MovieModel>[].obs;
  List<MovieModel> topratedMovies = <MovieModel>[].obs;
  List<MovieModel> popularMovies = <MovieModel>[].obs;
  List<MovieModel> upcomingMovies = <MovieModel>[].obs;
  List<MovieModel> similarMovies = <MovieModel>[].obs;
  List<MovieModel> searchedMovies = <MovieModel>[].obs;
  List<CastModel> movieCast = <CastModel>[].obs;
  List<MovieModel> allMovies = <MovieModel>[].obs;
  List<MovieModel> FavoriteMovies = <MovieModel>[].obs;

  var movies = MovieDetailModel(
    adult: null,
    backdropPath: null,
    genreIds: null,
    id: null,
    originalLanguage: null,
    originalTitle: null,
    overview: null,
    popularity: null,
    posterPath: null,
    releaseDate: null,
    title: null,
    video: null,
    voteAverage: null,
    voteCount: null,
  ).obs;

  @override
  void onInit() {
    getUpcoming();
    getToprated();
    getTrending();
    getPopular();
    super.onInit();
  }

  void getTrending() async {
    var movies = await apiClient.getTrendingMovies();
    if (movies.isNotEmpty) {
      trendingMovies = movies;
    }
    update();
  }

  void getToprated() async {
    var movies = await apiClient.getTopratedMovies();
    if (movies.isNotEmpty) {
      topratedMovies = movies;
    }
    update();
  }

  void getPopular() async {
    var movies = await apiClient.getPopularMovies();
    if (movies.isNotEmpty) {
      popularMovies = movies;
    }
    update();
  }

  void getUpcoming() async {
    var movies = await apiClient.getUpcomingMovies();
    if (movies.isNotEmpty) {
      upcomingMovies = movies;
    }
    update();
  }

  void getAll() async {
    var movies = await apiClient.allMovies();
    if (movies.isNotEmpty) {
      upcomingMovies = movies;
    }
    update();
  }

  void getSimilar(String id) async {
    var movies = await apiClient.getSimilarMovies(id);
    if (movies.isNotEmpty) {
      similarMovies = movies;
    }
    update();
  }

  void getCastList(String id) async {
    var cast = await apiClient.getMovieCast(id);
    if (cast.isNotEmpty) {
      movieCast = cast;
    }
    update();
  }

  void getMovieSearch(String movieTitle) async {
    var search = await apiClient.getSearchedMovies(movieTitle);
    if (search.isNotEmpty) {
      searchedMovies = search;
    }
    update();
  }

  void getDetail(String id) async {
    var movie = await apiClient.getMovieDetails(id);
    movies(movie);
    update();
  }

  void getMovieSearchFavorite() async {
    dynamic user = await FirebaseService.getUser();
    if (user != null) {
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      userRef.get().then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          Map<String, dynamic>? userData =
              snapshot.data() as Map<String, dynamic>?;

          List<String>? favoriteMovies =
              userData?['favoriteMovies']?.cast<String>();
        }
        for (var movie in FavoriteMovies){
          
        }
      });
    } 
    /*var search = await apiClient.getSearchedMovies();
    if (search.isNotEmpty) {
      searchedMovies = search;
    }*/
    update();
  }
}
