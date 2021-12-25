import 'package:flutter/material.dart';
import 'package:moview/models/favorites_model.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

import 'details/movie_details_page.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  late FavoritesModel _favorites = FavoritesModel(results: []);

  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      moview.hasUserLogged(context);
      _favorites = await moview.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: buildAppBar(
            context,
            title: "Favorites",
            action: IconButton(
              onPressed: () async {
                setState(() {
                  moview.favoritesIsLoading = true;
                });
                _favorites = await moview.getFavorites();
                setState(() {
                  moview.favoritesIsLoading = false;
                });
              },
              icon: Icon(Icons.refresh_rounded),
            ),
          ),
          body: moview.favoritesIsLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                  ),
                )
              : _favorites.results.isEmpty
                  ? Center(
                      child: Text("Your favorite list is empty :("),
                    )
                  : moview.timedOut
                      ? TimeOutWidget(
                          onRefresh: () async {
                            setState(() {
                              moview.favoritesIsLoading = true;
                            });
                            _favorites = await moview.getFavorites();
                            setState(() {
                              moview.favoritesIsLoading = false;
                            });
                          },
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 10,
                              mainAxisExtent:
                                  MediaQuery.of(context).size.height / 2.9,
                            ),
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: _favorites.results.length,
                            itemBuilder: (context, index) {
                              var favorite = _favorites.results[index];
                              return InkWell(
                                splashColor: Color(0xFF36367C),
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  if (favorite.type == 'tv') {
                                    animationTransition(
                                      context,
                                      TVShowDetails(
                                        id: favorite.id,
                                        title: favorite.title,
                                        posterPath: favorite.posterPath,
                                      ),
                                    );
                                  } else if (favorite.type == 'movie') {
                                    animationTransition(
                                      context,
                                      MovieDetails(
                                        id: favorite.id,
                                        title: favorite.title,
                                        posterPath: favorite.posterPath,
                                      ),
                                    );
                                  }
                                },
                                child: MoviewCard(
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  id: favorite.id,
                                  imageUrl: favorite.posterPath,
                                  title: favorite.title,
                                  rating: favorite.rating,
                                ),
                              );
                            },
                          ),
                        ),
        );
      },
    );
  }
}
