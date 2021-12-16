class TrendingMoviesModel {
  TrendingMoviesModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<TrendingMoviesResultModel> results;
  int totalPages;
  int totalResults;

  factory TrendingMoviesModel.fromJson(Map<String, dynamic> json) =>
      TrendingMoviesModel(
        page: json["page"],
        results: List<TrendingMoviesResultModel>.from(
            json["results"].map((x) => TrendingMoviesResultModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class TrendingMoviesResultModel {
  TrendingMoviesResultModel({
    required this.genreIds,
    required this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.title,
    required this.id,
  });

  List<int> genreIds;
  String posterPath;
  double voteAverage;
  DateTime releaseDate;
  String title;
  int id;

  factory TrendingMoviesResultModel.fromJson(Map<String, dynamic> json) =>
      TrendingMoviesResultModel(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
        releaseDate: DateTime.parse(json["release_date"]),
        title: json["title"],
        id: json["id"],
      );
}

class TrendingTvShowsModel {
  TrendingTvShowsModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<TrendingTvShowsResultModel> results;
  int totalPages;
  int totalResults;

  factory TrendingTvShowsModel.fromJson(Map<String, dynamic> json) =>
      TrendingTvShowsModel(
        page: json["page"],
        results: List<TrendingTvShowsResultModel>.from(
            json["results"].map((x) => TrendingTvShowsResultModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class TrendingTvShowsResultModel {
  TrendingTvShowsResultModel({
    required this.firstAirDate,
    required this.genreIds,
    required this.voteAverage,
    required this.id,
    required this.posterPath,
    required this.name,
  });

  DateTime firstAirDate;
  List<int> genreIds;
  double voteAverage;
  int id;
  String posterPath;
  String name;

  factory TrendingTvShowsResultModel.fromJson(Map<String, dynamic> json) =>
      TrendingTvShowsResultModel(
        firstAirDate: DateTime.parse(json["first_air_date"]),
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        voteAverage: json["vote_average"].toDouble(),
        id: json["id"],
        posterPath: json["poster_path"],
        name: json["name"],
      );
}
