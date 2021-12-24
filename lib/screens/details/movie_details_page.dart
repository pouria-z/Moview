import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marquee/marquee.dart';
import 'package:moview/models/movie_details_model.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
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
      moview.hasUserLogged(context);
      moview.movieDetailsModel = moview.getMovieDetails(widget.id);
      await moview.idSetting(widget.id, 'movie');
      isFavorite = moview.isFave;
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    var theme = Theme.of(context);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
            appBar: widget.title.characters.length < 30
                ? AppBar(
                    backgroundColor: theme.primaryColor,
                    title: Text(widget.title),
                  )
                : AppBar(
                    backgroundColor: theme.primaryColor,
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
                if (snapshot.hasError) {
                  return TimeOutWidget(
                    onRefresh: () {
                      setState(() {
                        moview.movieDetailsModel =
                            moview.getMovieDetails(widget.id);
                      });
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      Shimmer.fromColors(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3.5,
                          alignment: Alignment.topCenter,
                          color: theme.scaffoldBackgroundColor,
                        ),
                        baseColor: Color(0xFF2A3155),
                        highlightColor: theme.scaffoldBackgroundColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Hero(
                            tag: widget.posterPath,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://image.tmdb.org/t/p/w500${widget.posterPath}",
                                width: MediaQuery.of(context).size.width / 2.5,
                                height:
                                    MediaQuery.of(context).size.height / 3.7,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
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
                                      style: TextStyle(fontSize: 16),
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
                  List countries = [];
                  movie.spokenLanguages.forEach((element) {
                    spokenLanguages.add(element.englishName);
                  });
                  movie.genres.forEach((element) {
                    genres.add(element.name);
                  });
                  movie.productionCountries.forEach((element) {
                    countries.add(element.name);
                  });
                  return ListView(
                    physics: BouncingScrollPhysics(),
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///cover
                      CachedNetworkImage(
                        imageUrl:
                            "https://image.tmdb.org/t/p/original${movie.backdropPath}",
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3.5,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            Icon(Iconsax.danger5),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///poster
                            Hero(
                              tag: widget.posterPath,
                              child: PhysicalModel(
                                color: Colors.transparent,
                                elevation: 15,
                                borderRadius: BorderRadius.circular(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://image.tmdb.org/t/p/w500${widget.posterPath}",
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    height: MediaQuery.of(context).size.height /
                                        3.7,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        Icon(Iconsax.danger5),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),

                                  ///title
                                  Hero(
                                    tag: widget.id,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        widget.title,
                                        style: GoogleFonts.libreBaskerville(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),

                                  ///genres
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Genres: ",
                                          style: GoogleFonts.merriweather(
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: genres.join(", "),
                                          style: GoogleFonts.merriweather(),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ///rating
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              color: Colors.amber,
                                              size: 46,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: movie.voteAverage
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 28,
                                                      color: theme.colorScheme
                                                          .secondary,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: "/10",
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.white54,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "${movie.voteCount.toString()} people have voted",
                                              style: GoogleFonts.roboto(
                                                color: Colors.white54,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      ///add to favorites
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              isFavorite == null
                                                  ? "Add to your favorites"
                                                  : "Remove from your favorites",
                                              style: GoogleFonts.ubuntu(
                                                fontSize: 12,
                                                color: isFavorite == null
                                                    ? theme
                                                        .colorScheme.secondary
                                                    : Colors.red,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            IconButton(
                                              splashRadius: 22,
                                              onPressed: () async {
                                                setState(() {
                                                  isFavorite == null
                                                      ? isFavorite = true
                                                      : isFavorite = null;
                                                });
                                                await moview
                                                    .idSetting(
                                                        widget.id, 'movie')
                                                    .timeout(
                                                        Duration(seconds: 7),
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
                                                      content: Text(
                                                          'something went wrong!'),
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
                                                    releaseDate:
                                                        movie.releaseDate,
                                                    posterPath:
                                                        widget.posterPath,
                                                    isFavorite: isFavorite,
                                                  );
                                                } else if (moview.isFave ==
                                                    true) {
                                                  setState(() {
                                                    moview.isFave = isFavorite;
                                                  });
                                                  await moview.unsetFavorite();
                                                }
                                              },
                                              icon: isFavorite == true
                                                  ? Icon(
                                                      Iconsax.heart5,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(
                                                      Iconsax.heart,
                                                      color: theme.colorScheme
                                                          .secondary,
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            movie.tagline == ""
                                ? Container()
                                : Text(
                                    "${movie.tagline}\n",
                                    style: GoogleFonts.dancingScript(
                                      fontSize: 18,
                                    ),
                                  ),
                            movie.releaseDate == ""
                                ? Container()
                                : RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Release Date: ",
                                          style: GoogleFonts.merriweather(
                                            color: theme.colorScheme.secondary,
                                          ),
                                        ),
                                        TextSpan(
                                          text: movie.releaseDate
                                              .replaceRange(4, 5, "/")
                                              .replaceRange(7, 8, "/"),
                                          style: GoogleFonts.merriweather(),
                                        ),
                                      ],
                                    ),
                                  ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Overview: ",
                                    style: GoogleFonts.merriweather(
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: movie.overview,
                                    style: GoogleFonts.merriweather(),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "\nSpoken Languages: ",
                                    style: GoogleFonts.merriweather(
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: spokenLanguages.join(", "),
                                    style: GoogleFonts.merriweather(),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Production Country: ",
                                    style: GoogleFonts.merriweather(
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: countries.join(", "),
                                    style: GoogleFonts.merriweather(),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Runtime: ",
                                    style: GoogleFonts.merriweather(
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "${movie.runtime.toString()} minutes",
                                    style: GoogleFonts.merriweather(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ));
      },
    );
  }
}
