import 'package:flutter/material.dart';
import 'package:moview/models/genres_model.dart';
import 'package:moview/widgets.dart';
import 'package:moview/screens/genre/genre_details_page.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: buildAppBar(context, "Genres"),
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
  // late Future<MovieGenresModel> _movieGenresData;
  Future<MovieGenresModel>? movieGenresModel;
  var response;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var moview = Provider.of<Moview>(context, listen: false);
      movieGenresModel = moview.getMovieGenres();
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
            future: movieGenresModel,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return moview.timedOut == true
                    ? TimeOutWidget(
                        onRefresh: () {
                          setState(() {
                            moview.getMovieGenres();
                          });
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.movieGenres.length,
                        itemBuilder: (context, index) {
                          var movieGenres = snapshot.data!.movieGenres[index];
                          return ListTile(
                            title: Text(movieGenres.name),
                            leading: Icon(Icons.star_rounded),
                            onTap: () {
                              moview.getGenreResultListIsLoading = true;
                              moview.genreResultNameList.clear();
                              moview.genreResultIdList.clear();
                              moview.genreResultPosterList.clear();
                              moview.genreResultPosterUrlList.clear();
                              moview.genreResultRateList.clear();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenreDetails(
                                      type: 'movie',
                                      id: movieGenres.id,
                                      name: movieGenres.name,
                                      pageNumber: 1,
                                    ),
                                  ));
                            },
                          );
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

class _TVShowGenresState extends State<TVShowGenres> {
  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if (moview.genreTvShowNameList.isEmpty) {
        setState(() {
          moview.getTvShowGenreList();
        });
      } else {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          body: moview.timedOut == true
              ? TimeOutWidget(
                  onRefresh: () {
                    setState(() {
                      moview.getTvShowGenreList();
                    });
                  },
                )
              : moview.genreTvShowNameList.isEmpty ||
                      moview.genreTvShowIdList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: moview.genreTvShowIdList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(moview.genreTvShowNameList[index]),
                          leading: Icon(Icons.star_rounded),
                          onTap: () {
                            moview.getGenreResultListIsLoading = true;
                            moview.genreResultNameList.clear();
                            moview.genreResultIdList.clear();
                            moview.genreResultPosterList.clear();
                            moview.genreResultPosterUrlList.clear();
                            moview.genreResultRateList.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GenreDetails(
                                    type: 'tv',
                                    id: moview.genreTvShowIdList[index],
                                    name: moview.genreTvShowNameList[index],
                                    pageNumber: 1,
                                  ),
                                ));
                          },
                        );
                      },
                    ),
        );
      },
    );
  }
}
