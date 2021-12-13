import 'dart:convert';
import 'package:http/http.dart';
import 'package:moview/key.dart';

class GenresModel {
  GenresModel({
    required this.genres,
  });

  List<Genre> genres;

  factory GenresModel.fromJson(Map<String, dynamic> json) => GenresModel(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
      };
}

class Genre {
  Genre({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}


class APIManager {

  Future<GenresModel> getGenres() async {
    var url = Uri.https("api.themoviedb.org", "/3/genre/movie/list",
        {'api_key': '$apiKey', 'language': 'en-US'});
    Response response = await get(url);
    var jsonBody = jsonDecode(response.body);
    var genresModel = GenresModel.fromJson(jsonBody);
    return genresModel;

  }

}
