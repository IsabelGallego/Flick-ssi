import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flickssi/models/cast_model.dart';
import 'package:flickssi/models/movie_detail_model.dart';
import 'package:flickssi/models/movie_model.dart';

class ApiConstants {
  static const String baseUrl = "https://api.themoviedb.org/3/";
  static const String apiKEY = "api_key=3c9040f95b5d47d6ea8d351d697a9551";
  static const String baseImgUrl = "https://image.tmdb.org/t/p/w500";
}

class ApiClient extends GetxController {
  Future<List<MovieModel>> getTrendingMovies() async {
    String uri =
        '${ApiConstants.baseUrl}trending/movie/week?${ApiConstants.apiKEY}';

    try {
      http.Response response = await http.get(Uri.parse(uri));
      final data = json.decode(response.body);
      var result = data['results'];

      List<MovieModel> movies = [];
      for (var movie in result) {
        movies.add(MovieModel.fromJson(movie));
      }

      return movies;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getTopratedMovies() async {
    String uri =
        '${ApiConstants.baseUrl}movie/top_rated?${ApiConstants.apiKEY}&language=en-US&page=1';

    try {
      http.Response response = await http.get(Uri.parse(uri));
      final data = json.decode(response.body);
      var result = data['results'];

      List<MovieModel> movies = [];
      for (var movie in result) {
        movies.add(MovieModel.fromJson(movie));
      }

      return movies;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getPopularMovies() async {
    String uri =
        '${ApiConstants.baseUrl}movie/popular?${ApiConstants.apiKEY}&language=en-US&page=1';
    try {
      http.Response response = await http.get(Uri.parse(uri));
      final data = json.decode(response.body);
      var result = data['results'];

      List<MovieModel> movies = [];
      for (var movie in result) {
        movies.add(MovieModel.fromJson(movie));
      }

      return movies;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getUpcomingMovies() async {
    String uri =
        '${ApiConstants.baseUrl}movie/upcoming?${ApiConstants.apiKEY}&language=en-US&page=1';
    try {
      http.Response response = await http.get(Uri.parse(uri));
      final data = json.decode(response.body);
      var result = data['results'];

      List<MovieModel> movies = [];
      for (var movie in result) {
        movies.add(MovieModel.fromJson(movie));
      }
      return movies;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getSimilarMovies(String movieId) async {
    String uri =
        '${ApiConstants.baseUrl}movie/$movieId/similar?${ApiConstants.apiKEY}&language=en-US&page=1';

    try {
      http.Response response = await http.get(Uri.parse(uri));
      final data = json.decode(response.body);
      var result = data['results'];

      List<MovieModel> movies = [];
      for (var movie in result) {
        movies.add(MovieModel.fromJson(movie));
      }
      return movies;
    } catch (e) {
      rethrow;
    }
  }

  Future<MovieDetailModel> getMovieDetails(String movieId) async {
    String uri =
        '${ApiConstants.baseUrl}movie/$movieId?${ApiConstants.apiKEY}&language=en-US';

    try {
      http.Response response = await http.get(Uri.parse(uri));
      final data = json.decode(response.body);

      MovieDetailModel details = MovieDetailModel.fromJson(data);

      return details;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CastModel>> getMovieCast(String movieId) async {
    String uri =
        '${ApiConstants.baseUrl}movie/$movieId/credits?${ApiConstants.apiKEY}&language=en-US';
    try {
      http.Response response = await http.get(Uri.parse(uri));
      final data = json.decode(response.body);
      var result = data['cast'];

      List<CastModel> movieCast = [];
      for (var cast in result) {
        movieCast.add(CastModel.fromJson(cast));
      }
      return movieCast;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieModel>> getSearchedMovies(String movieName) async {
    String uri =
        '${ApiConstants.baseUrl}search/movie?${ApiConstants.apiKEY}&language=en-US&page=1&include_adult=false&query=$movieName';
    try {
      http.Response response = await http.get(Uri.parse(uri));
      final data = json.decode(response.body);
      var results = data['results'];

      List<MovieModel> searchMovie = [];
      for (var movie in results) {
        searchMovie.add(MovieModel.fromJson(movie));
      }
      return searchMovie;
    } catch (e) {
      rethrow;
    }
  }
  


  allMovies() {}
}
