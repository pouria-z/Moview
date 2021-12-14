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

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
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
  DateTime releaseDate;
  String title;
  double voteAverage;

  factory Result.fromJson(Map<String, dynamic> json, String mediaType) =>
      Result(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        posterPath: json["poster_path"] ?? "",
        releaseDate: mediaType == "movie" ? DateTime.parse(json["release_date"]) : json["first_air_date"],
        title: mediaType == "movie" ? json["title"] : json["name"],
        voteAverage: json["vote_average"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "title": title,
        "vote_average": voteAverage,
      };
}
