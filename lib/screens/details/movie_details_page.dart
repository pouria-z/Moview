import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:moview/models/movie_details_model.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetails extends StatefulWidget {
  final int id;
  final String title;
  final String posterPath;

  const MovieDetails(
      {required this.id, required this.title, required this.posterPath});

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  var isFavorite;

  @override
  void initState() {
    super.initState();
    print("movie id: ${widget.id}");
    var moview = Provider.of<Moview>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      moview.movieDetailsModel = moview.getMovieDetails(widget.id);
      await moview.idSetting(widget.id, 'movie');
      isFavorite = moview.isFave;
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
            appBar: widget.title.characters.length < 30
                ? AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Text(widget.title),
                  )
                : AppBar(
                    backgroundColor: Theme.of(context).primaryColor,
                    flexibleSpace: SafeArea(
                      child: Marquee(
                        text: widget.title,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        scrollAxis: Axis.horizontal,
                        blankSpace: MediaQuery.of(context).size.width / 2,
                        velocity: 100.0,
                        pauseAfterRound: Duration(seconds: 1),
                        showFadingOnlyWhenScrolling: false,
                        fadingEdgeStartFraction: 0.3,
                        fadingEdgeEndFraction: 0.5,
                        numberOfRounds: 5,
                        startPadding: 50.0,
                        decelerationCurve: Curves.linearToEaseOut,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ),
            body: FutureBuilder<MovieDetailsModel>(
              future: moview.movieDetailsModel,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      Shimmer.fromColors(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3.5,
                          alignment: Alignment.topCenter,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        baseColor: Theme.of(context).scaffoldBackgroundColor,
                        highlightColor: Colors.grey,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: widget.posterPath,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://image.tmdb.org/t/p/w500${widget.posterPath}",
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 3,
                              alignment: Alignment.center,
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Hero(
                                  tag: widget.id,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      widget.title,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                } else {
                  final movie = snapshot.data!;
                  List spokenLanguages = [];
                  List genres = [];
                  movie.spokenLanguages.forEach((element) {
                    spokenLanguages.add(element.englishName);
                  });
                  movie.genres.forEach((element) {
                    genres.add(element.name);
                  });
                  return Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/w500${movie.backdropPath}",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.5,
                        fit: BoxFit.fill,
                        alignment: Alignment.topCenter,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: widget.posterPath,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://image.tmdb.org/t/p/w500${widget.posterPath}",
                              width: MediaQuery.of(context).size.width / 2,
                              height: MediaQuery.of(context).size.height / 3,
                              alignment: Alignment.center,
                            ),
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Hero(
                                  tag: widget.id,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      widget.title,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        isFavorite == null
                                            ? isFavorite = true
                                            : isFavorite = null;
                                      });
                                      await moview
                                          .idSetting(widget.id, 'movie')
                                          .timeout(Duration(seconds: 5),
                                              onTimeout: () {
                                        setState(() {
                                          isFavorite == null
                                              ? isFavorite = true
                                              : isFavorite = null;
                                          moview.isFave = isFavorite;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('something went wrong!'),
                                          ),
                                        );
                                      });
                                      if (moview.isFave == null) {
                                        setState(() {
                                          moview.isFave = isFavorite;
                                        });
                                        await moview.setFavorite(
                                          id: widget.id,
                                          type: 'movie',
                                          title: widget.title,
                                          releaseDate: movie.releaseDate,
                                          posterPath: widget.posterPath,
                                        );
                                      } else if (moview.isFave == true) {
                                        setState(() {
                                          moview.isFave = isFavorite;
                                        });
                                        await moview.unsetFavorite();
                                      }
                                    },
                                    icon: isFavorite == true
                                        ? Icon(
                                            Icons.favorite_rounded,
                                            color: Colors.red,
                                          )
                                        : Icon(
                                            Icons.favorite_border_rounded,
                                          )),
                              ],
                            ),
                          )
                        ],
                      ),
                      Text(movie.tagline),
                      Text(spokenLanguages.join(", ")),
                      Text(genres.join(", ")),
                    ],
                  );
                }
              },
            ));
      },
    );
  }
}
