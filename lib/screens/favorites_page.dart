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

  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      moview.hasUserLogged(context);
      moview.favoritesModel = moview.getFavorites();
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
            action: Container(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              moview.favoritesModel = moview.getFavorites();
            },
            elevation: 7,
            child: Icon(Icons.refresh_rounded),
          ),
          body: FutureBuilder<FavoritesModel>(
            future: moview.favoritesModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.results.isEmpty) {
                return Center(
                  child: Text("no data!"),
                );
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 10,
                    mainAxisExtent: MediaQuery.of(context).size.height / 3,
                  ),
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.results.length,
                  itemBuilder: (context, index) {
                    var favorite = snapshot.data!.results[index];
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
                        height: MediaQuery.of(context).size.height / 3,
                        id: favorite.id,
                        imageUrl: favorite.posterPath,
                        title: favorite.title,
                        rating: 8.0,
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
