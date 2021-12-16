class SearchMoviesModel {
  SearchMoviesModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<SearchMoviesResultsModel> results;
  int totalPages;
  int totalResults;

  factory SearchMoviesModel.fromJson(Map<String, dynamic> json) =>
      SearchMoviesModel(
        page: json["page"],
        results: List<SearchMoviesResultsModel>.from(
            json["results"].map((x) => SearchMoviesResultsModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class SearchMoviesResultsModel {
  SearchMoviesResultsModel({
    required this.genreIds,
    required this.id,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
  });

  List<int> genreIds;
  int id;
  String posterPath;
  String releaseDate;
  String title;
  double voteAverage;

  factory SearchMoviesResultsModel.fromJson(Map<String, dynamic> json) =>
      SearchMoviesResultsModel(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        posterPath: json["poster_path"] ?? "",
        releaseDate: json["release_date"] == null || json["release_date"] == ""
            ? "Unknown"
            : json["release_date"].toString().replaceRange(4, 10, ""),
        title: json["title"] == null ? null : json["title"],
        voteAverage: json["vote_average"].toDouble(),
      );
}

class SearchTvShowsModel {
  SearchTvShowsModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<SearchTvShowsResultsModel> results;
  int totalPages;
  int totalResults;

  factory SearchTvShowsModel.fromJson(Map<String, dynamic> json) =>
      SearchTvShowsModel(
        page: json["page"],
        results: List<SearchTvShowsResultsModel>.from(
            json["results"].map((x) => SearchTvShowsResultsModel.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class SearchTvShowsResultsModel {
  SearchTvShowsResultsModel({
    required this.genreIds,
    required this.id,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
  });

  List<int> genreIds;
  int id;
  String posterPath;
  String releaseDate;
  String title;
  double voteAverage;

  factory SearchTvShowsResultsModel.fromJson(Map<String, dynamic> json) =>
      SearchTvShowsResultsModel(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        posterPath: json["poster_path"] ?? "",
        releaseDate: json["first_air_date"] == null || json["first_air_date"] == ""
            ? "Unknown"
            : json["first_air_date"].toString().replaceRange(4, 10, ""),
        title: json["name"],
        voteAverage: json["vote_average"].toDouble(),
      );
}

