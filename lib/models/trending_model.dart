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
  String releaseDate;
  String title;
  int id;

  factory TrendingMoviesResultModel.fromJson(Map<String, dynamic> json) =>
      TrendingMoviesResultModel(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        posterPath: json["poster_path"] ?? "",
        voteAverage: json["vote_average"].toDouble(),
        releaseDate: json["release_date"].toString().replaceRange(4, 10, ""),
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
    required this.releaseDate,
    required this.genreIds,
    required this.voteAverage,
    required this.id,
    required this.posterPath,
    required this.title,
  });

  String releaseDate;
  List<int> genreIds;
  double voteAverage;
  int id;
  String posterPath;
  String title;

  factory TrendingTvShowsResultModel.fromJson(Map<String, dynamic> json) =>
      TrendingTvShowsResultModel(
        releaseDate: json["first_air_date"].toString().replaceRange(4, 10, ""),
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        voteAverage: json["vote_average"].toDouble(),
        id: json["id"],
        posterPath: json["poster_path"] ?? "",
        title: json["name"],
      );
}
