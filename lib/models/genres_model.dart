import 'dart:convert';
import 'package:http/http.dart';
import 'package:moview/key.dart';

class MovieGenresModel {
  MovieGenresModel({
    required this.movieGenres,
  });

  List<MovieGenres> movieGenres;

  factory MovieGenresModel.fromJson(Map<String, dynamic> json) =>
      MovieGenresModel(
        movieGenres: List<MovieGenres>.from(
          json["genres"].map((x) => MovieGenres.fromJson(x)),
        ),
      );


  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(movieGenres.map((x) => x.toJson())),
      };
}

class MovieGenres {
  MovieGenres({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory MovieGenres.fromJson(Map<String, dynamic> json) => MovieGenres(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class TvShowGenresModel {
  TvShowGenresModel({
    required this.tvShowGenres,
  });

  List<TvShowGenres> tvShowGenres;

  factory TvShowGenresModel.fromJson(Map<String, dynamic> json) =>
      TvShowGenresModel(
        tvShowGenres: List<TvShowGenres>.from(
            json["genres"].map((x) => TvShowGenres.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "genres": List<dynamic>.from(tvShowGenres.map((x) => x.toJson())),
      };
}

class TvShowGenres {
  TvShowGenres({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory TvShowGenres.fromJson(Map<String, dynamic> json) => TvShowGenres(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
