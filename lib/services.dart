import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:moview/key.dart';
import 'package:http/http.dart';
import 'package:moview/screens/home_page.dart';
import 'package:moview/widgets.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:moview/screens/intro/intro_page.dart';

class Moview with ChangeNotifier {
  String apiUrl = "api.themoviedb.org";
  String imageUrl = "https://image.tmdb.org/t/p/w500";
  var type; // 'movie' or 'tv'
  bool timeOutException = false;
  ///Movie Genre List
  var genreMediaId;
  var genreMovieName;
  List genreMovieIdList = [];
  List genreMovieNameList = [];

  ///TvShow Genre List
  var genreTvShowId;
  var genreTvShowName;
  List genreTvShowIdList = [];
  List genreTvShowNameList = [];

  ///Movie Details
  bool getMovieDetailsIsLoading = false;
  var movieName;
  var movieGenre;
  List movieGenreList = [];
  var movieOverview;
  var movieCover;
  var movieCoverUrl;
  var moviePoster;
  var moviePosterUrl;
  var movieCountry;
  List movieCountryList = [];
  var movieReleaseDate;
  var movieRuntime;
  var movieLanguages;
  List movieLanguagesList = [];
  var movieTagLine;

  ///TVShow Details
  bool getTvShowDetailsIsLoading = false;
  var tvShowName;
  var tvShowGenre;
  List tvShowGenreList = [];
  var tvShowOverview;
  var tvShowCover;
  var tvShowCoverUrl;
  var tvShowPoster;
  var tvShowPosterUrl;
  var tvShowRuntime;
  var tvShowFirstAir;
  var tvShowCreatedBy;
  List tvShowCreatedByList = [];
  var tvShowLastAir;
  var tvShowEpisodes;
  var tvShowSeasons;
  var tvShowCountry;
  List tvShowCountryList = [];
  var tvShowSeasonName;
  List tvShowSeasonNameList = [];
  var tvShowSeasonAirDate;
  List tvShowSeasonAirDateList = [];
  var tvShowSeasonPoster;
  List tvShowSeasonPosterList = [];
  var tvShowLanguages;
  List tvShowLanguagesList = [];
  var tvShowTagLine;

  ///Search Result
  bool isLoadingMore = false;
  bool isSearching = false;
  var searchInput;
  var searchPage;
  var searchTotalPages;
  var searchTotalResults;
  var searchName;
  var searchPoster;
  var searchPosterUrl;
  var searchId;
  var searchRate;
  var searchOverview;
  var searchMediaType;
  List searchNameList = [];
  List searchPosterList = [];
  List searchIdList = [];
  List searchRateList = [];
  List searchOverviewList = [];
  List searchMediaTypeList = [];
  List searchPosterUrlList = [];
  var count = 0;
  var personCount = 0;

  ///Search On Typing
  bool isSearchingOnType = false;
  var searchTypeInput;
  var searchTypeName;
  var searchTypePoster;
  var searchTypePosterUrl;
  var searchTypeId;
  var searchTypeRate;
  var searchTypeMediaType;
  List searchTypeNameList = [];
  List searchTypePosterList = [];
  List searchTypePosterUrlList = [];
  List searchTypeIdList = [];
  List searchTypeRateList = [];
  List searchTypeMediaTypeList = [];
  var typeCount = 0;
  var typePersonCount = 0;

  ///Genre Result List
  bool genreResultListIsLoadingMore = false;
  bool getGenreResultListIsLoading = false;
  var genreResultPage;
  var genreResultName;
  var genreResultId;
  var genreResultPoster;
  var genreResultPosterUrl;
  var genreResultRate;
  var genreResultTotalPages;
  List genreResultPageList = [];
  List genreResultNameList = [];
  List genreResultIdList = [];
  List genreResultPosterList = [];
  List genreResultPosterUrlList = [];
  List genreResultRateList = [];

  ///favorite
  var objectId;
  var favoriteId;
  var theId;
  var theObject;
  var isFave;

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

  Future getMovieGenreList() async {
    timeOutException = false;
    genreMovieNameList.clear();
    genreMovieIdList.clear();
    var url = Uri.https(apiUrl, "/3/genre/movie/list",
        {'api_key': '$apiKey', 'language': 'en-US'});
    late Response response;
    try {
      response = await get(url).timeout(Duration(seconds: 15));
    } on TimeoutException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    }
    var json = jsonDecode(response.body);
    for (var item in json['genres']) {
      genreMediaId = item['id'];
      genreMovieName = item['name'];
      genreMovieNameList.add(genreMovieName);
      genreMovieIdList.add(genreMediaId);
    }
    notifyListeners();
  }

  Future getTvShowGenreList() async {
    timeOutException = false;
    genreTvShowNameList.clear();
    genreTvShowIdList.clear();
    var url = Uri.https(apiUrl, "/3/genre/tv/list",
        {'api_key': '$apiKey', 'language': 'en-US'});
    late Response response;
    try {
      response = await get(url).timeout(Duration(seconds: 15));
    } on TimeoutException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    }
    var json = jsonDecode(response.body);
    for (var item in json['genres']) {
      genreTvShowId = item['id'];
      genreTvShowName = item['name'];
      genreTvShowNameList.add(genreTvShowName);
      genreTvShowIdList.add(genreTvShowId);
    }
    notifyListeners();
  }

  Future getMovieDetails(int movieId) async {
    timeOutException = false;
    movieName = null;
    movieCover = null;
    moviePoster = null;
    movieLanguagesList.clear();
    movieCountryList.clear();
    movieGenreList.clear();
    getMovieDetailsIsLoading = true;
    var url = Uri.https(apiUrl, '/3/movie/$movieId',
        {'api_key': '$apiKey', 'language': 'en-US'});
    late Response response;
    try {
      response = await get(url).timeout(Duration(seconds: 15));
    } on TimeoutException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    }
    var json = jsonDecode(response.body);
    movieId = json['id'];
    movieName = json['title'];
    movieOverview = json['overview'];
    movieCover = json['backdrop_path'];
    moviePoster = json['poster_path'];
    movieReleaseDate = json['release_date'];
    movieRuntime = json['runtime'];
    movieTagLine = json['tagline'];
    for (var item in json['spoken_languages']) {
      movieLanguages = item['english_name'];
      movieLanguagesList.add(movieLanguages);
    }
    for (var item in json['production_countries']) {
      movieCountry = item['name'];
      movieCountryList.add(movieCountry);
    }
    for (var item in json['genres']) {
      movieGenre = item['name'];
      movieGenreList.add(movieGenre);
    }
    movieCoverUrl = imageUrl + movieCover;
    moviePosterUrl = imageUrl + moviePoster;
    getMovieDetailsIsLoading = false;
    notifyListeners();
  }

  Future getTvShowDetails(int tvShowId) async {
    timeOutException = false;
    getTvShowDetailsIsLoading = true;
    tvShowName = null;
    tvShowCover = null;
    tvShowPoster = null;
    tvShowSeasonAirDateList.clear();
    tvShowSeasonNameList.clear();
    tvShowSeasonPosterList.clear();
    tvShowCreatedByList.clear();
    tvShowGenreList.clear();
    tvShowLanguagesList.clear();
    tvShowCountryList.clear();
    var url = Uri.https(
        apiUrl, '/3/tv/$tvShowId', {'api_key': '$apiKey', 'language': 'en-US'});
    late Response response;
    try {
      response = await get(url).timeout(Duration(seconds: 15));
    } on TimeoutException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    }
    var json = jsonDecode(response.body);
    tvShowId = json['id'];
    tvShowName = json['name'];
    tvShowOverview = json['overview'];
    tvShowCover = json['backdrop_path'];
    tvShowPoster = json['poster_path'];
    tvShowTagLine = json['tagline'];
    for (var i in json['episode_run_time']) {
      tvShowRuntime = "";
      tvShowRuntime = i;
    }
    tvShowFirstAir = json['first_air_date'];
    tvShowLastAir = json['last_air_date'];
    tvShowEpisodes = json['number_of_episodes'];
    tvShowSeasons = json['number_of_seasons'];
    for (var item in json['created_by']) {
      tvShowCreatedBy = item['name'];
      tvShowCreatedByList.add(tvShowCreatedBy);
    }
    for (var item in json['production_countries']) {
      tvShowCountry = item['name'];
      tvShowCountryList.add(tvShowCountry);
    }
    for (var item in json['seasons']) {
      tvShowSeasonAirDate = item['air_date'];
      tvShowSeasonName = item['name'];
      tvShowSeasonPoster = item['poster_path'];
      tvShowSeasonAirDateList.add(tvShowSeasonAirDate);
      tvShowSeasonNameList.add(tvShowSeasonName);
      tvShowSeasonPosterList.add(tvShowSeasonPoster);
    }
    for (var item in json['spoken_languages']) {
      tvShowLanguages = item['name'];
      tvShowLanguagesList.add(tvShowLanguages);
    }
    for (var item in json['genres']) {
      tvShowGenre = item['name'];
      tvShowGenreList.add(tvShowGenre);
    }
    if (tvShowCover != null) {
      tvShowCoverUrl = imageUrl + tvShowCover;
    }
    if (tvShowPoster != null) {
      tvShowPosterUrl = imageUrl + tvShowPoster;
    }
    getTvShowDetailsIsLoading = false;
    notifyListeners();
  }

  Future getSearchResults() async {
    timeOutException = false;
    isLoadingMore = true;
    isSearching = true;
    var url = Uri.https(apiUrl, '/3/search/multi', {
      'api_key': '$apiKey',
      'language': 'en-US',
      'page': '$searchPage',
      'query': '$searchInput',
      'include_adult': 'false'
    });
    late Response response;
    try {
      response = await get(url).timeout(Duration(seconds: 15));
    } on TimeoutException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    }
    var json = jsonDecode(response.body);
    searchTotalPages = json['total_pages'];
    searchTotalResults = json['total_results'];
    for (var item in json['results']) {
      count++;
      searchMediaType = item['media_type'];
      if (searchMediaType == 'tv' || searchMediaType == 'movie') {
        searchMediaTypeList.add(searchMediaType);
        searchPoster = item['poster_path'];
        searchId = item['id'];
        searchRate = item['vote_average'];
        searchOverview = item['overview'];
        if (searchMediaType == 'tv') {
          searchName = item['name'];
        } else if (searchMediaType == 'movie') {
          searchName = item['title'];
        }
        searchNameList.add(searchName);
        searchPosterList.add(searchPoster);
        searchIdList.add(searchId);
        searchRateList.add(searchRate);
        searchOverviewList.add(searchOverview);
        searchPosterUrl = searchPoster != null ? imageUrl + searchPoster : "";
        searchPosterUrlList.add(searchPosterUrl);
      } else if (searchMediaType == 'person') {
        personCount++;
        print('its person');
      }
    }
    print('there are $personCount persons');
    print('result is ${count - personCount}');
    isLoadingMore = false;
    isSearching = false;
    notifyListeners();
  }

  Future getSearchOnType() async {
    timeOutException = false;
    isSearchingOnType = true;
    searchTypeNameList.clear();
    searchTypeRateList.clear();
    searchTypePosterList.clear();
    searchTypePosterUrlList.clear();
    searchTypeIdList.clear();
    searchTypeMediaTypeList.clear();
    var url = Uri.https(apiUrl, '/3/search/multi', {
      'api_key': '$apiKey',
      'language': 'en-US',
      'page': '1',
      'query': '$searchTypeInput',
      'include_adult': 'false'
    });
    late Response response;
    try {
      response = await get(url).timeout(Duration(seconds: 15));
    } on TimeoutException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    }
    var json = jsonDecode(response.body);
    searchTypeNameList.clear();
    searchTypeRateList.clear();
    searchTypePosterList.clear();
    searchTypePosterUrlList.clear();
    searchTypeIdList.clear();
    searchTypeMediaTypeList.clear();
    for (var item in json['results']) {
      typeCount++;
      searchTypeMediaType = item['media_type'];
      if (searchTypeMediaType == 'tv' || searchTypeMediaType == 'movie') {
        searchTypeMediaTypeList.add(searchTypeMediaType);
        searchTypePoster = item['poster_path'];
        searchTypeId = item['id'];
        searchTypeRate = item['vote_average'];
        if (searchTypeMediaType == 'tv') {
          searchTypeName = item['name'];
        } else if (searchTypeMediaType == 'movie') {
          searchTypeName = item['title'];
        }
        searchTypeNameList.add(searchTypeName);
        searchTypePosterList.add(searchTypePoster);
        searchTypeIdList.add(searchTypeId);
        searchTypeRateList.add(searchTypeRate);
        searchTypePosterUrl =
            searchTypePoster != null ? imageUrl + searchTypePoster : "";
        searchTypePosterUrlList.add(searchTypePosterUrl);
      } else if (searchTypeMediaType == 'person') {
        typePersonCount++;
        print('its person');
      }
    }
    isSearchingOnType = false;
    notifyListeners();
  }

  Future getGenreResultList(String mediaType, int genreMediaId) async {
    timeOutException = false;
    genreResultListIsLoadingMore = true;
    getGenreResultListIsLoading = true;
    var url = Uri.https(apiUrl, '/3/discover/$mediaType', {
      'api_key': '$apiKey',
      'language': 'en-US',
      'sort_by': 'popularity.desc',
      'include_adult': 'false',
      'include_video': 'false',
      'page': '$genreResultPage',
      'with_genres': '$genreMediaId'
    });
    late Response response;
    try {
      response = await get(url).timeout(Duration(seconds: 15));
    } on TimeoutException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    } on SocketException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    }
    var json = jsonDecode(response.body);
    genreResultTotalPages = json['total_pages'];
    for (var item in json['results']) {
      if (mediaType == 'tv') {
        genreResultName = item['name'];
        genreResultNameList.add(genreResultName);
      } else if (mediaType == 'movie') {
        genreResultName = item['title'];
        genreResultNameList.add(genreResultName);
      }
      genreResultId = item['id'];
      genreResultIdList.add(genreResultId);
      genreResultPoster = item['poster_path'];
      genreResultRate = item['vote_average'];
      genreResultPosterList.add(genreResultPoster);
      genreResultRateList.add(genreResultRate);
      genreResultPosterUrl =
          genreResultPoster != null ? imageUrl + genreResultPoster : "";
      genreResultPosterUrlList.add(genreResultPosterUrl);
    }
    genreResultListIsLoadingMore = false;
    getGenreResultListIsLoading = false;
    notifyListeners();
  }

  ///Database
  Future setFavorite(int favoriteMediaId, String favoriteType) async {
    // set security
    ParseUser user = await ParseUser.currentUser();
    final acl = ParseACL(owner: user);
    acl.setPublicReadAccess(allowed: false);
    acl.setPublicWriteAccess(allowed: false);
    // set movie/tv data to database
    final data = ParseObject('favorites')
      ..set('mediaId', favoriteMediaId)
      ..set('id', favoriteId)
      ..set('mediaType', favoriteType)
      ..set('mediaName', favoriteType == 'movie' ? movieName : tvShowName)
      ..set('year', favoriteType == 'movie' ? movieReleaseDate : tvShowFirstAir)
      ..set('mediaPoster',
          favoriteType == 'movie' ? moviePosterUrl : tvShowPosterUrl)
      ..set('isFavorite', isFave)
      ..setACL(acl);
    final response = await data.save();
    objectId = (response.results!.first as ParseObject).objectId;
    print('$favoriteType with $objectId id saved successfully!');
    notifyListeners();
  }

  Future setAndGetId(int favoriteMediaId, String favoriteType) async {
    isFave = null;
    theObject = null;
    theId = null;
    favoriteId = null;
    // set id for media in database
    var url = Uri.https(apiUrl, '/3/$favoriteType/$favoriteMediaId',
        {'api_key': '$apiKey', 'language': 'en-US'});
    ParseUser user = await ParseUser.currentUser();
    var _userId = user.objectId;
    var _id = _userId.toString() +
        '$favoriteType' +
        favoriteMediaId.toString() +
        url.toString();
    favoriteId = _id.hashCode;
    // find if the movie/tv is marked as favorite or not
    QueryBuilder<ParseObject> query =
        QueryBuilder<ParseObject>(ParseObject('favorites'))
          ..whereEqualTo('id', favoriteId);
    final response = await query.find();
    if (response.isNotEmpty) {
      theObject = response.single.objectId;
      theId = response.single.get('id');
      isFave = response.single.get('isFavorite');
      print(
          '$favoriteType is in favorite list.\nid is: $theId,\tobjectId is: $theObject');
    } else {
      print("this $favoriteType is not user's favorite!");
    }
    notifyListeners();
  }

  Future unsetFavorite() async {
    // delete complete row in database
    final data = ParseObject('favorites')
      ..objectId = theObject
      ..delete();
    await data.save();
    print('movie/tv with $theObject id deleted successfully.');
    notifyListeners();
  }

  ///User
  Future getUser() async {
    timeOutException = false;
    // get current user details
    try {
      ParseUser parseUser =
          await ParseUser.currentUser().timeout(Duration(seconds: 15));
      username = parseUser.username;
      email = parseUser.emailAddress;
      password = parseUser.password;
    } on SocketException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    }
    notifyListeners();
  }

  Future<bool> hasUserLogged(context) async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    final ParseResponse? parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

    if (parseResponse?.success == null || !parseResponse!.success) {
      //Invalid session. Logout
      await currentUser.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Sorry you have to go :("),
        ),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IntroPage(),
          ));
      return false;
    } else {
      return true;
    }
  }

  void register(context, username, password, email) async {
    print('signing up...');
    var user = ParseUser.createUser(username, password, email);
    late ParseResponse response;
    try {
      response = await user.signUp().timeout(Duration(seconds: 10));
    } on TimeoutException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('something went wrong. please try again!'),
        ),
      );
      throw e;
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('something went wrong. please try again!'),
        ),
      );
      throw e;
    }
    if (response.success) {
      print('user created successfully');
    } else if (response.error!.code == -1) {
      print(response.error!.message);
      message(context, "Check your connection");
    } else {
      print(response.error!.message);
      message(context, response.error!.message);
    }
    notifyListeners();
  }

  void login(context, username, password) async {
    print('logging in...');
    var user = ParseUser(username, password, null);
    late ParseResponse response;
    try {
      response = await user.login().timeout(Duration(seconds: 10));
    } on TimeoutException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('something went wrong. please try again!'),
        ),
      );
      throw e;
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('something went wrong. please try again!'),
        ),
      );
      throw e;
    }
    if (response.success) {
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
    notifyListeners();
  }

  void logout(context) async {
    username = null;
    password = null;
    email = null;
    print('logging out...');
    var user = ParseUser(username, password, email);
    late ParseResponse response;
    try {
      response = await user.logout().timeout(Duration(seconds: 10));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('something went wrong. please try again!'),
        ),
      );
      throw error;
    }
    if (response.success) {
      favoriteNumbers = null;
      genreMovieIdList.clear();
      genreMovieNameList.clear();
      genreTvShowIdList.clear();
      genreTvShowNameList.clear();
      movieGenreList.clear();
      movieCountryList.clear();
      movieLanguagesList.clear();
      tvShowGenreList.clear();
      tvShowCreatedByList.clear();
      tvShowCountryList.clear();
      tvShowSeasonNameList.clear();
      tvShowSeasonAirDateList.clear();
      tvShowSeasonPosterList.clear();
      tvShowLanguagesList.clear();
      searchNameList.clear();
      searchPosterList.clear();
      searchIdList.clear();
      searchRateList.clear();
      searchOverviewList.clear();
      searchMediaTypeList.clear();
      searchPosterUrlList.clear();
      genreResultPageList.clear();
      genreResultNameList.clear();
      genreResultIdList.clear();
      genreResultPosterList.clear();
      genreResultPosterUrlList.clear();
      genreResultRateList.clear();
      dbMediaIdList.clear();
      dbMediaNameList.clear();
      dbYearList.clear();
      print('user logged out successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IntroPage(),
          ));
    } else if (response.error!.code == -1) {
      print(response.error!.message);
      message(context, "Check your connection");
    } else {
      print(response.error!.message);
      message(context, response.error!.message);
    }
    notifyListeners();
  }

  ///Favorite Page
  Future favoritesList() async {
    timeOutException = false;
    favoriteListIsLoading = true;
    favoriteNumbers = null;
    dbMediaIdList.clear();
    dbMediaNameList.clear();
    dbYearList.clear();
    dbFavoriteTypeList.clear();
    dbMediaPosterList.clear();
    QueryBuilder<ParseObject> queryBuilder =
        QueryBuilder<ParseObject>(ParseObject('favorites'));
    var i = await queryBuilder.count();
    favoriteNumbers = i.count;
    print('total favorites: $favoriteNumbers');
    late ParseResponse dbResponse;
    try {
      dbResponse = await queryBuilder.query();
    } on SocketException catch (e) {
      timeOutException = true;
      notifyListeners();
      throw e;
    }
    var json = jsonDecode((dbResponse.results).toString());
    // get all favorites from database
    if (json != null) {
      for (var item in json) {
        dbMediaId = item['mediaId'];
        dbMediaIdList.add(dbMediaId);
        dbFavoriteType = item['mediaType'];
        dbFavoriteTypeList.add(dbFavoriteType);
        dbMediaName = item['mediaName'];
        dbMediaNameList.add(dbMediaName);
        dbYear = item['year'];
        dbYearList.add(dbYear);
        dbMediaPoster = item['mediaPoster'];
        dbMediaPosterList.add(dbMediaPoster);
      }
    }
    favoriteListIsLoading = false;
    notifyListeners();
  }
}
