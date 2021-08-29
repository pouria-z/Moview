import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';

class MovieDetails extends StatefulWidget {
  final id;

  const MovieDetails({Key? key, @required this.id}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    print("movie id: ${widget.id}");
    var moview = Provider.of<Moview>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      moview.favoriteType = 'movie';
      moview.favoriteMediaId = widget.id;
      moview.movieId = widget.id;
      moview.setAndGetId();
      moview.getMovieDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: moview.movieName.toString().characters.length < 30
              ? AppBar(
                  title: Text(
                    moview.movieName == null ? "" : moview.movieName,
                    style: TextStyle(fontSize: 25),
                  ),
                )
              : AppBar(
                  flexibleSpace: SafeArea(
                    child: moview.movieName == null
                        ? Container()
                        : Marquee(
                            text: moview.movieName,
                            style: TextStyle(fontSize: 25, color: Colors.white),
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
          body: moview.movieName == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Image.network(
                      moview.movieCoverUrl,
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
                        Image.network(
                          moview.moviePosterUrl,
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          alignment: Alignment.center,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                moview.movieName,
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await moview.setAndGetId();
                                    if (moview.theId == null) {
                                      setState(() {
                                        isFavorite = !isFavorite;
                                        moview.theId = moview.favoriteId;
                                      });
                                      await moview.setFavorite();
                                    } else if (moview.theId ==
                                        moview.favoriteId) {
                                      setState(() {
                                        isFavorite = !isFavorite;
                                      });
                                      await moview.unsetFavorite().whenComplete(
                                              () => moview.favoriteId = null);
                                    }
                                  },
                                  icon: moview.theId == moview.favoriteId
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
                    Text(moview.movieTagLine),
                    Text(moview.movieLanguagesList.toString()),
                    Text(moview.movieGenreList.toString()),
                  ],
                ),
        );
      },
    );
  }
}
