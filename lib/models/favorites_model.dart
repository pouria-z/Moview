class FavoritesModel {
  FavoritesModel({required this.results});
  List<FavoritesResultsModel> results;
}

class FavoritesResultsModel {
  FavoritesResultsModel({
    required this.id,
    required this.type,
    required this.title,
    required this.year,
    required this.posterPath,
  });

  int id;
  String type;
  String title;
  String year;
  String posterPath;
}
