import 'package:flutter/material.dart';
import 'package:moview/screens/genre/genre_details_page.dart';
import 'package:moview/services.dart';
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
      body: SafeArea(
        child: Column(
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
      ),
    );
  }
}

class MovieGenres extends StatefulWidget {
  const MovieGenres({Key? key}) : super(key: key);

  @override
  _MovieGenresState createState() => _MovieGenresState();
}

class _MovieGenresState extends State<MovieGenres> {
  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if (moview.genreMovieNameList.isEmpty) {
        moview.favoritesList();
        await moview.getMovieGenreList();
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
          body: moview.genreMovieNameList.isEmpty ||
                  moview.genreMovieIdList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: moview.genreMovieIdList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(moview.genreMovieNameList[index]),
                      leading: Icon(Icons.star_rounded),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenreDetails(
                                type: 'movie',
                                id: moview.genreMovieIdList[index],
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
        await moview.getTvShowGenreList();
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
          body: moview.genreTvShowNameList.isEmpty ||
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenreDetails(
                                type: 'tv',
                                id: moview.genreTvShowIdList[index],
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
