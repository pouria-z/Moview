class MovieDetailsModel {
  MovieDetailsModel({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.originalLanguage,
    required this.overview,
    required this.posterPath,
    required this.productionCountries,
    required this.releaseDate,
    required this.runtime,
    required this.spokenLanguages,
    required this.tagline,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  String backdropPath;
  List<Genre> genres;
  int id;
  String originalLanguage;
  String overview;
  String posterPath;
  List<ProductionCountry> productionCountries;
  String releaseDate;
  int runtime;
  List<SpokenLanguage> spokenLanguages;
  String tagline;
  String title;
  double voteAverage;
  int voteCount;

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) =>
      MovieDetailsModel(
        backdropPath: json["backdrop_path"] ?? "",
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        id: json["id"],
        originalLanguage: json["original_language"],
        overview: json["overview"],
        posterPath: json["poster_path"] ?? "",
        productionCountries: List<ProductionCountry>.from(
            json["production_countries"]
                .map((x) => ProductionCountry.fromJson(x))),
        releaseDate: json["release_date"] ?? "",
        runtime: json["runtime"] ?? 0,
        spokenLanguages: List<SpokenLanguage>.from(
            json["spoken_languages"].map((x) => SpokenLanguage.fromJson(x))),
        tagline: json["tagline"] ?? "",
        title: json["title"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
      );
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
}

class ProductionCountry {
  ProductionCountry({
    required this.name,
  });

  String name;

  factory ProductionCountry.fromJson(Map<String, dynamic> json) =>
      ProductionCountry(
        name: json["name"],
      );
}

class SpokenLanguage {
  SpokenLanguage({
    required this.englishName,
  });

  String englishName;

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
        englishName: json["english_name"],
      );
}
