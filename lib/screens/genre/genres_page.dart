import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moview/models/genres_model.dart';
import 'package:moview/widgets.dart';
import 'package:moview/screens/genre/genre_details_page.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';
import 'package:moview/models/genre_result_model.dart';

class GenresPage extends StatefulWidget {
  @override
  _GenresPageState createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Genres", action: Container(),),
      body: Column(
        children: [
          Material(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              controller: _controller,
              tabs: [
                Tab(
                  text: 'Movie',
                ),
                Tab(
                  text: 'TV Show',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [
                MovieGenres(),
                TVShowGenres(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MovieGenres extends StatefulWidget {
  const MovieGenres({Key? key}) : super(key: key);

  @override
  _MovieGenresState createState() => _MovieGenresState();
}

class _MovieGenresState extends State<MovieGenres>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var moview = Provider.of<Moview>(context, listen: false);
      print("this future");
      moview.movieGenresModel = moview.getMovieGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final favorite = await moview.favoritesList();
              print(
                "total: ${favorite.results.length}"
              );
            },
            child: Icon(Iconsax.import),
          ),
          body: moview.timedOut == true
              ? TimeOutWidget(
                  onRefresh: () {
                    setState(() {
                      moview.movieGenresModel = moview.getMovieGenres();
                    });
                  },
                )
              : FutureBuilder<MovieGenresModel>(
                  future: moview.movieGenresModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.movieGenres.length,
                        itemBuilder: (context, index) {
                          var movieGenres = snapshot.data!.movieGenres[index];
                          return ListTile(
                            title: Text(movieGenres.name),
                            leading: Icon(Icons.star_rounded),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenreDetails(
                                    type: 'movie',
                                    id: movieGenres.id,
                                    name: movieGenres.name,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      print("*** error: ${snapshot.error.toString()}");
                      TimeOutWidget(
                        onRefresh: () {
                          setState(() {
                            moview.movieGenresModel = moview.getMovieGenres();
                          });
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TVShowGenres extends StatefulWidget {
  const TVShowGenres({Key? key}) : super(key: key);

  @override
  _TVShowGenresState createState() => _TVShowGenresState();
}

class _TVShowGenresState extends State<TVShowGenres>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var moview = Provider.of<Moview>(context, listen: false);
      print("this future");
      moview.tvShowGenresModel = moview.getTvShowGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          body: moview.timedOut == true
              ? TimeOutWidget(
                  onRefresh: () {
                    setState(() {
                      moview.tvShowGenresModel = moview.getTvShowGenres();
                    });
                  },
                )
              : FutureBuilder<TvShowGenresModel>(
                  future: moview.tvShowGenresModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.tvShowGenres.length,
                        itemBuilder: (context, index) {
                          var tvShowGenres = snapshot.data!.tvShowGenres[index];
                          return ListTile(
                            title: Text(tvShowGenres.name),
                            leading: Icon(Icons.star_rounded),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenreDetails(
                                    type: 'tv',
                                    id: tvShowGenres.id,
                                    name: tvShowGenres.name,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      print("====== ${snapshot.error.toString()}");
                      TimeOutWidget(
                        onRefresh: () {
                          setState(() {
                            moview.tvShowGenresModel = moview.getTvShowGenres();
                          });
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
