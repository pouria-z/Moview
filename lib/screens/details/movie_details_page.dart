import 'package:flutter/material.dart';
import 'package:moview/widgets.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieDetails extends StatefulWidget {
  final id;

  const MovieDetails({Key? key, @required this.id}) : super(key: key);

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
    moview.timeOutException = false;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await moview.setAndGetId(widget.id, 'movie');
      isFavorite = moview.isFave;
      await moview.getMovieDetails(widget.id);
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
          body: moview.timeOutException == true
              ? TimeOutWidget(
                  function: () {
                    setState(() {
                      moview.getMovieDetails(widget.id);
                    });
                  },
                )
              : moview.getMovieDetailsIsLoading == true
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: moview.movieCoverUrl,
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
                            CachedNetworkImage(
                              imageUrl: moview.moviePosterUrl,
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
                                        setState(() {
                                          isFavorite == null
                                              ? isFavorite = true
                                              : isFavorite = null;
                                        });
                                        await moview
                                            .setAndGetId(widget.id, 'movie')
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
                                          await moview.setFavorite(widget.id, 'movie');
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
