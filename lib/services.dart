import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:moview/key.dart';
import 'package:moview/models/favorites_model.dart';
import 'package:moview/models/genre_result_model.dart';
import 'package:moview/models/genres_model.dart';
import 'package:moview/models/images_model.dart';
import 'package:moview/models/movie_details_model.dart';
import 'package:moview/models/search_model.dart';
import 'package:moview/models/trending_model.dart';
import 'package:moview/models/tvshow_details_model.dart';
import 'package:moview/screens/genre/genre_details_page.dart';
import 'package:moview/screens/home_page.dart';
import 'package:moview/screens/intro/login_page.dart';
import 'package:moview/screens/search/search_results_page.dart';
import 'package:moview/widgets.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Moview with ChangeNotifier {
  String apiUrl = "api.themoviedb.org";
  String imageUrl = "https://image.tmdb.org/t/p/w500";
  String _apiUrl = "https://api.themoviedb.org/3";
  bool timedOut = false;
  bool showBottom = true;

  ///Parse User
  var username;
  var email;
  var password;

  ///Get Favorites
  var favoriteNumbers;
  var dbMediaId;
  var dbFavoriteType;
  var dbMediaName;
  var dbYear;
  var dbMediaPoster;
  List dbFavoriteTypeList = [];
  List dbMediaIdList = [];
  List dbMediaNameList = [];
  List dbYearList = [];
  List dbMediaPosterList = [];
  bool favoriteListIsLoading = false;

  List images = [];

  Future getImages() async {
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('MoviesImages'));
    final response = await queryBuilder.query();
    final json = jsonDecode((response.results).toString());
    if (json != null) {
      for (var item in json) {
        images.add(item["image"]["url"]);
      }
    }
    notifyListeners();
  }

  Future<Response> sendRequest(Uri url) async {
    print("starting to send request");
    late Response response;
    try {
      response = await get(url).timeout(
        Duration(seconds: 15),
      );
    } on TimeoutException catch (e) {
      timedOut = true;
      GenreDetails.refreshController.loadFailed();
      GenreDetails.refreshController.refreshFailed();
      SearchMoviesResultsPage.refreshController.loadFailed();
      SearchTvShowsResultsPage.refreshController.loadFailed();
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      timedOut = true;
      GenreDetails.refreshController.loadFailed();
      GenreDetails.refreshController.refreshFailed();
      SearchMoviesResultsPage.refreshController.loadFailed();
      SearchTvShowsResultsPage.refreshController.loadFailed();
      notifyListeners();
      throw e;
    }
    return response;
  }

  Future<MovieGenresModel>? movieGenresModel;

  Future<MovieGenresModel> getMovieGenres() async {
    timedOut = false;
    notifyListeners();
    MovieGenresModel _movieGenresModel;
    var url =
        Uri.parse('$_apiUrl/genre/movie/list?api_key=$apiKey&language=en-US');
    Response _response = await sendRequest(url);
    print('request completed!');
    Map<String, dynamic> jsonBody = jsonDecode(_response.body);
    _movieGenresModel = MovieGenresModel.fromJson(jsonBody);
    _movieGenresModel.movieGenres.removeAt(5);
    notifyListeners();
    return _movieGenresModel;
  }

  Future<TvShowGenresModel>? tvShowGenresModel;

  Future<TvShowGenresModel> getTvShowGenres() async {
    timedOut = false;
    notifyListeners();
    TvShowGenresModel _tvShowGenresModel;
    var url =
        Uri.parse('$_apiUrl/genre/tv/list?api_key=$apiKey&language=en-US');
    Response _response = await sendRequest(url);
    Map<String, dynamic> jsonBody = jsonDecode(_response.body);
    _tvShowGenresModel = TvShowGenresModel.fromJson(jsonBody);
    _tvShowGenresModel.tvShowGenres.removeAt(12);
    _tvShowGenresModel.tvShowGenres.removeAt(10);
    _tvShowGenresModel.tvShowGenres.removeAt(9);
    notifyListeners();
    return _tvShowGenresModel;
  }

  Future<SearchMoviesModel>? searchMoviesModel;
  late int searchMoviesTotalPages;
  int searchMoviesPage = 1;

  Future<SearchMoviesModel> getSearchMovies(String searchInput) async {
    timedOut = false;
    notifyListeners();
    late SearchMoviesModel _searchMoviesModel;
    print("Searching for $searchInput...");
    var url = Uri.parse("$_apiUrl/search/movie?api_key=$apiKey&language=en-US&"
        "page=$searchMoviesPage&query=$searchInput&include_adult=false");
    Response _response = await sendRequest(url);
    Map<String, dynamic> jsonBody = jsonDecode(_response.body);
    _searchMoviesModel = SearchMoviesModel.fromJson(jsonBody);
    searchMoviesTotalPages = _searchMoviesModel.totalPages;
    notifyListeners();
    return _searchMoviesModel;
  }

  Future<SearchTvShowsModel>? searchTvShowsModel;
  late int searchTvShowsTotalPages;
  int searchTvShowsPage = 1;

  Future<SearchTvShowsModel> getSearchTvShows(String searchInput) async {
    timedOut = false;
    notifyListeners();
    late SearchTvShowsModel _searchTvShowsModel;
    var url = Uri.parse("$_apiUrl/search/tv?api_key=$apiKey&language=en-US&"
        "page=$searchTvShowsPage&query=$searchInput&include_adult=false");
    Response _response = await sendRequest(url);
    Map<String, dynamic> jsonBody = jsonDecode(_response.body);
    _searchTvShowsModel = SearchTvShowsModel.fromJson(jsonBody);
    searchTvShowsTotalPages = _searchTvShowsModel.totalPages;
    notifyListeners();
    return _searchTvShowsModel;
  }

  Future<TrendingMoviesModel>? trendingMoviesModel;

  Future<TrendingMoviesModel> getTrendingMovies() async {
    timedOut = false;
    notifyListeners();
    late TrendingMoviesModel _trendingMoviesModel;
    var url = Uri.parse("$_apiUrl/trending/movie/week?api_key=$apiKey&page=1");
    Response _response = await sendRequest(url);
    Map<String, dynamic> jsonBody = jsonDecode(_response.body);
    _trendingMoviesModel = TrendingMoviesModel.fromJson(jsonBody);
    notifyListeners();
    return _trendingMoviesModel;
  }

  Future<TrendingTvShowsModel>? trendingTvShowsModel;

  Future<TrendingTvShowsModel> getTrendingTvShows() async {
    timedOut = false;
    notifyListeners();
    late TrendingTvShowsModel _trendingTvShowsModel;
    var url = Uri.parse("$_apiUrl/trending/tv/week?api_key=$apiKey&page=1");
    Response _response = await sendRequest(url);
    Map<String, dynamic> jsonBody = jsonDecode(_response.body);
    _trendingTvShowsModel = TrendingTvShowsModel.fromJson(jsonBody);
    notifyListeners();
    return _trendingTvShowsModel;
  }

  int genreResultPage = 0;
  late int genreResultTotalPages;

  Future<GenreResultModel> getGenreResult(
      String mediaType, int genreMediaId) async {
    timedOut = false;
    notifyListeners();
    GenreResultModel _genreResultModel;
    var url = Uri.parse(
        '$_apiUrl/discover/$mediaType?api_key=$apiKey&language=en-US&sort_by=popularity.desc'
        '&include_adult=false&include_video=false&page=$genreResultPage&with_genres=$genreMediaId');
    Response _response = await sendRequest(url);
    print("request completed!");
    Map<String, dynamic> jsonBody = jsonDecode(_response.body);
    _genreResultModel = GenreResultModel.fromJson(jsonBody, mediaType);
    genreResultTotalPages = _genreResultModel.totalPages;
    notifyListeners();
    return _genreResultModel;
  }

  Future<MovieDetailsModel>? movieDetailsModel;

  Future<MovieDetailsModel> getMovieDetails(int movieId) async {
    timedOut = false;
    notifyListeners();
    late MovieDetailsModel _movieDetailsModel;
    var url =
        Uri.parse("$_apiUrl/movie/$movieId?api_key=$apiKey&language=en-US");
    Response _response = await sendRequest(url);
    Map<String, dynamic> jsonBody = jsonDecode(_response.body);
    _movieDetailsModel = MovieDetailsModel.fromJson(jsonBody);
    notifyListeners();
    return _movieDetailsModel;
  }

  Future<TvShowDetailsModel>? tvShowDetailsModel;

  Future<TvShowDetailsModel> getTvShowDetails(int tvShowId) async {
    timedOut = false;
    notifyListeners();
    late TvShowDetailsModel _tvShowDetailsModel;
    var url =
        Uri.parse("$_apiUrl/tv/$tvShowId?api_key=$apiKey&languages=en-US");
    Response _response = await sendRequest(url);
    Map<String, dynamic> jsonBody = jsonDecode(_response.body);
    _tvShowDetailsModel = TvShowDetailsModel.fromJson(jsonBody);
    notifyListeners();
    return _tvShowDetailsModel;
  }

  ///Database

  late int uniqueId;
  var object;
  var isFave;

  Future idSetting(int id, String type) async {
    isFave = null;
    object = null;
    // set id for media in database
    String _url = "$_apiUrl/$type/$id?api_key=$apiKey&language=en-US";
    ParseUser user = await ParseUser.currentUser();
    final _userId = user.objectId;
    var _uniqueId = _userId.toString() + type + id.toString() + _url;
    uniqueId = _uniqueId.hashCode;
    // find if the movie/tv is marked as favorite or not
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('favorites'))
          ..whereEqualTo('uniqueId', uniqueId);
    final response = await query.find();
    if (response.isNotEmpty) {
      object = response.single.objectId;
      int dbUniqueId = response.single.get('uniqueId');
      isFave = response.single.get('isFavorite');
      print(
          '$type is in favorite list.\nuniqueId is: $dbUniqueId,\tobjectId is: $object');
    } else {
      print("this $type is not user's favorite!");
    }
    notifyListeners();
  }

  late String objectId;

  Future setFavorite({
    required int id,
    required String type,
    required String title,
    required String releaseDate,
    required String posterPath,
  }) async {
    // set security
    ParseUser user = await ParseUser.currentUser();
    final acl = ParseACL(owner: user);
    acl.setPublicReadAccess(allowed: false);
    acl.setPublicWriteAccess(allowed: false);
    // set movie/tv data to database
    final data = ParseObject('favorites')
      ..set('id', id)
      ..set('uniqueId', uniqueId)
      ..set('type', type)
      ..set('title', title)
      ..set('releaseDate', releaseDate)
      ..set('posterPath', imageUrl + posterPath)
      ..set('isFavorite', isFave)
      ..setACL(acl);
    final response = await data.save();
    objectId = (response.results!.first as ParseObject).objectId!;
    print('$type with $objectId objectId saved successfully!');
    notifyListeners();
  }

  Future unsetFavorite() async {
    // delete complete row in database
    final data = ParseObject('favorites')
      ..objectId = object
      ..delete();
    await data.save();
    print('media with $object objectId deleted successfully.');
    notifyListeners();
  }

  ///User
  Future getUser() async {
    timedOut = false;
    // get current user details
    try {
      ParseUser parseUser =
          await ParseUser.currentUser().timeout(Duration(seconds: 15));
      username = parseUser.username;
      email = parseUser.emailAddress;
      password = parseUser.password;
    } on SocketException catch (e) {
      timedOut = true;
      notifyListeners();
      throw e;
    }
    notifyListeners();
  }

  Future<bool> hasUserLogged(context) async {
    print('checking if user token is valid');
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

    if (parseResponse?.success == null || !parseResponse!.success) {
      showBottom = false;
      //Invalid session. Logout
      await currentUser.logout();
      message(context, 'something went wrong! please login again.');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
      return false;
    } else {
      return true;
    }
  }

  bool registerIsLoading = false;

  Future<void> register(context,
      {required String username,
      required String password,
      required String email}) async {
    print('signing up...');
    registerIsLoading = true;
    notifyListeners();
    var user = ParseUser.createUser(username, password, email);
    late ParseResponse response;
    try {
      response = await user.signUp().timeout(Duration(seconds: 10));
    } on TimeoutException catch (e) {
      message(context, 'something went wrong. please try again!');
      registerIsLoading = false;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      message(context, 'something went wrong. please try again!');
      registerIsLoading = false;
      notifyListeners();
      throw e;
    }
    if (response.success) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Verify your email",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
                "An email containing a link to verify your email, was sent to $email."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text("Ok"),
              ),
            ],
          );
        },
      );
    } else if (response.error!.code == -1) {
      print(response.error!.message);
      message(context, "Check your connection");
    } else {
      print(response.error!.message);
      message(context, response.error!.message);
    }
    registerIsLoading = false;
    notifyListeners();
  }

  bool loginIsLoading = false;

  Future<void> login(context, username, password) async {
    print('logging in...');
    loginIsLoading = true;
    notifyListeners();
    var user = ParseUser(username, password, null);
    late ParseResponse response;
    try {
      response = await user.login().timeout(Duration(seconds: 10));
    } on TimeoutException catch (e) {
      message(context, 'something went wrong. please try again!');
      loginIsLoading = false;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      message(context, 'something went wrong. please try again!');
      loginIsLoading = false;
      notifyListeners();
      throw e;
    }
    if (response.success) {
      showBottom = true;
      print('user logged in successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } else if (response.error!.code == -1) {
      print(response.error!.message);
      message(context, "Check your connection");
    } else {
      print(response.error!.message);
      message(context, response.error!.message);
    }
    loginIsLoading = false;
    notifyListeners();
  }

  Future<void> logout(context) async {
    username = null;
    password = null;
    email = null;
    print('logging out...');
    var user = ParseUser(username, password, email);
    late ParseResponse response;
    try {
      response = await user.logout().timeout(Duration(seconds: 10));
    } on TimeoutException catch (e) {
      message(context, 'something went wrong! please try again.');
      throw e;
    } on SocketException catch (e) {
      message(context, 'something went wrong! please try again.');
      throw e;
    }
    if (response.success) {
      showBottom = false;
      favoriteNumbers = null;
      dbMediaIdList.clear();
      dbMediaNameList.clear();
      dbYearList.clear();
      print('user logged out successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else if (response.error!.code == -1) {
      print(response.error!.message);
      message(context, "Check your connection");
    } else {
      print(response.error!.message);
      message(context, response.error!.message);
    }
    notifyListeners();
  }

  bool resetPasswordIsLoading = false;

  Future<void> resetPassword(context, {required String emailAddress}) async {
    print('resetting password...');
    resetPasswordIsLoading = true;
    notifyListeners();
    var user = ParseUser(null, null, emailAddress);
    late ParseResponse response;
    try {
      response =
          await user.requestPasswordReset().timeout(Duration(seconds: 10));
    } on TimeoutException catch (e) {
      message(context, 'something went wrong. please try again!');
      resetPasswordIsLoading = false;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      message(context, 'something went wrong. please try again!');
      resetPasswordIsLoading = false;
      notifyListeners();
      throw e;
    }
    if (response.success) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Check your email",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
                "An email containing a link to reset your password, was sent to $email."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text("Ok"),
              ),
            ],
          );
        },
      );
    } else {
      print(response.error);
      message(context, 'Cannot find a user with this email address.');
    }
    resetPasswordIsLoading = false;
    notifyListeners();
  }

  ///Favorite Page

  Future<FavoritesModel>? favoritesModel;

  Future<FavoritesModel> getFavorites() async {
    late FavoritesModel _favorites = FavoritesModel(results: []);
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('favorites'));
    var i = await queryBuilder.count();
    favoriteNumbers = i.count;
    print('total favorites: $favoriteNumbers');
    late ParseResponse dbResponse;
    try {
      dbResponse = await queryBuilder.query();
    } on SocketException catch (e) {
      timedOut = true;
      notifyListeners();
      throw e;
    }
    final json = jsonDecode((dbResponse.results).toString());
    if (json != null) {
      for (var item in json) {
        _favorites.results.add(
          FavoritesResultsModel(
            id: item["id"],
            type: item["type"],
            title: item["title"],
            year: item["year"],
            posterPath: item["posterPath"],
          ),
        );
      }
    }
    notifyListeners();
    return _favorites;
  }
}
