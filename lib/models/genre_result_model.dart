class GenreResultModel {
  GenreResultModel({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Result> results;
  int totalPages;
  int totalResults;

  factory GenreResultModel.fromJson(
          Map<String, dynamic> json, String mediaType) =>
      GenreResultModel(
        page: json["page"],
        results: List<Result>.from(
            json["results"].map((x) => Result.fromJson(x, mediaType))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}

class Result {
  Result({
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

  factory Result.fromJson(Map<String, dynamic> json, String mediaType) =>
      Result(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        posterPath: json["poster_path"] ?? "",
        releaseDate: mediaType == "movie"
            ? json["release_date"] == null || json["release_date"] == ""
                ? "Unknown"
                : json["release_date"].toString().replaceRange(4, 10, "")
            : json["first_air_date"] == null || json["first_air_date"] == ""
                ? "Unknown"
                : json["first_air_date"].toString().replaceRange(4, 10, ""),
        title: mediaType == "movie" ? json["title"] : json["name"],
        voteAverage: json["vote_average"].toDouble(),
      );
}
