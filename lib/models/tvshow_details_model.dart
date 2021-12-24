class TvShowDetailsModel {
  TvShowDetailsModel({
    required this.backdropPath,
    required this.createdBy,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.title,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.overview,
    required this.posterPath,
    required this.productionCountries,
    required this.seasons,
    required this.spokenLanguages,
    required this.tagline,
    required this.voteAverage,
    required this.voteCount,
  });

  String backdropPath;
  List<CreatedBy> createdBy;
  List<int> episodeRunTime;
  String firstAirDate;
  List<Genre> genres;
  int id;
  String title;
  List<Network> networks;
  int numberOfEpisodes;
  int numberOfSeasons;
  String overview;
  String posterPath;
  List<ProductionCountry> productionCountries;
  List<Season> seasons;
  List<SpokenLanguage> spokenLanguages;
  String tagline;
  double voteAverage;
  int voteCount;

  factory TvShowDetailsModel.fromJson(Map<String, dynamic> json) =>
      TvShowDetailsModel(
        backdropPath: json["backdrop_path"] ?? "",
        createdBy: List<CreatedBy>.from(
            json["created_by"].map((x) => CreatedBy.fromJson(x))),
        episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
        firstAirDate: json["first_air_date"],
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        id: json["id"],
        title: json["name"],
        networks: List<Network>.from(
            json["networks"].map((x) => Network.fromJson(x))),
        numberOfEpisodes: json["number_of_episodes"] ?? 0,
        numberOfSeasons: json["number_of_seasons"] ?? 0,
        overview: json["overview"],
        posterPath: json["poster_path"] ?? "",
        productionCountries: List<ProductionCountry>.from(
            json["production_countries"]
                .map((x) => ProductionCountry.fromJson(x))),
        seasons:
            List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
        spokenLanguages: List<SpokenLanguage>.from(
            json["spoken_languages"].map((x) => SpokenLanguage.fromJson(x))),
        tagline: json["tagline"] ?? "",
        voteAverage: json["vote_average"].toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
      );
}

class CreatedBy {
  CreatedBy({
    required this.name,
  });

  String name;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        name: json["name"],
      );
}

class Genre {
  Genre({
    required this.name,
  });

  String name;

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        name: json["name"],
      );
}

class Network {
  Network({
    required this.name,
  });

  String name;

  factory Network.fromJson(Map<String, dynamic> json) => Network(
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

class Season {
  Season({
    required this.airDate,
    required this.episodeCount,
    required this.name,
    required this.posterPath,
    required this.seasonNumber,
  });

  String airDate;
  int episodeCount;
  String name;
  String posterPath;
  int seasonNumber;

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        airDate: json["air_date"] ?? "",
        episodeCount: json["episode_count"] ?? 0,
        name: json["name"] ?? "",
        posterPath: json["poster_path"] ?? "",
        seasonNumber: json["season_number"],
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
