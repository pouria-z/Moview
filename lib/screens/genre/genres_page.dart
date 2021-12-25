import 'package:flutter/material.dart';
import 'package:moview/models/genres_model.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

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
      appBar: buildAppBar(
        context,
        title: "Genres",
        action: Container(),
      ),
      body: Column(
        children: [
          Material(
            color: Theme.of(context).primaryColor,
            child: TabBar(
              controller: _controller,
              indicatorColor: Colors.orangeAccent,
              labelColor: Colors.orangeAccent,
              unselectedLabelColor: Colors.grey,
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
          body: FutureBuilder<MovieGenresModel>(
            future: moview.movieGenresModel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return moviewGenreList(
                  snapshot,
                  type: 'movie',
                  data: snapshot.data!.movieGenres,
                  images: moview.moviesImages,
                );
              } else if (snapshot.hasError) {
                print("*** error: ${snapshot.error.toString()}");
                return TimeOutWidget(
                  onRefresh: () {
                    setState(() {
                      moview.movieGenresModel = moview.getMovieGenres();
                    });
                  },
                );
              }
              return GenreListLoading();
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
                      return moviewGenreList(
                        snapshot,
                        type: "tv",
                        data: snapshot.data!.tvShowGenres,
                        images: moview.tvShowsImages,
                      );
                    } else if (snapshot.hasError) {
                      print("====== ${snapshot.error.toString()}");
                      return TimeOutWidget(
                        onRefresh: () {
                          setState(() {
                            moview.tvShowGenresModel = moview.getTvShowGenres();
                          });
                        },
                      );
                    }
                    return GenreListLoading();
                  },
                ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
