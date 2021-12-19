class Favorites {
  Favorites({required this.results});
  List<FavoritesModel> results;
}

class FavoritesModel {
  FavoritesModel({
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
