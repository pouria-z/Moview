class FavoritesModel {
  FavoritesModel({required this.results});
  List<FavoritesResultsModel> results;
}

class FavoritesResultsModel {
  FavoritesResultsModel({
    required this.id,
    required this.type,
    required this.title,
    required this.posterPath,
    required this.rating,
  });

  int id;
  String type;
  String title;
  String posterPath;
  double rating;
}
