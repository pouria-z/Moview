import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marquee/marquee.dart';
import 'package:moview/models/tvshow_details_model.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TVShowDetails extends StatefulWidget {
  final int id;
  final String title;
  final String posterPath;

  const TVShowDetails(
      {required this.id, required this.title, required this.posterPath});

  @override
  _TVShowDetailsState createState() => _TVShowDetailsState();
}

class _TVShowDetailsState extends State<TVShowDetails> {
  var isFavorite;
  double height = 1;

  @override
  void initState() {
    super.initState();
    print("tv show id: ${widget.id}");
    var moview = Provider.of<Moview>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      moview.hasUserLogged(context);
      moview.tvShowDetailsModel = moview.getTvShowDetails(widget.id);
      await moview.idSetting(widget.id, 'tv');
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
          body: FutureBuilder<TvShowDetailsModel>(
            future: moview.tvShowDetailsModel,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return TimeOutWidget(
                  onRefresh: () {
                    setState(() {
                      moview.tvShowDetailsModel =
                          moview.getTvShowDetails(widget.id);
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
                              height: MediaQuery.of(context).size.height / 3.7,
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
                                    style: GoogleFonts.libreBaskerville(
                                      fontSize: 18,
                                    ),
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
                final tvShow = snapshot.data!;
                List spokenLanguages = [];
                List genres = [];
                List countries = [];
                List createdBy = [];
                List network = [];
                tvShow.spokenLanguages.forEach((element) {
                  spokenLanguages.add(element.englishName);
                });
                tvShow.genres.forEach((element) {
                  genres.add(element.name);
                });
                tvShow.productionCountries.forEach((element) {
                  countries.add(element.name);
                });
                tvShow.createdBy.forEach((element) {
                  createdBy.add(element.name);
                });
                tvShow.networks.forEach((element) {
                  network.add(element.name);
                });
                return ListView(
                  physics: BouncingScrollPhysics(),
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///cover
                    CachedNetworkImage(
                      imageUrl:
                          "https://image.tmdb.org/t/p/original${tvShow.backdropPath}",
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
                                  height:
                                      MediaQuery.of(context).size.height / 3.7,
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
                                                  text: tvShow.voteAverage
                                                      .toString(),
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 28,
                                                    color: theme
                                                        .colorScheme.secondary,
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
                                            "${tvShow.voteCount.toString()} people have voted",
                                            textAlign: TextAlign.center,
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
                                                  ? theme.colorScheme.secondary
                                                  : Colors.red,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          AnimatedScale(
                                            scale: height,
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: IconButton(
                                              splashRadius: 22,
                                              onPressed: () async {
                                                await Future.delayed(
                                                    Duration(milliseconds: 10),
                                                    () {
                                                  setState(() {
                                                    height = 3;
                                                  });
                                                });
                                                Future.delayed(
                                                    Duration(milliseconds: 20),
                                                    () {
                                                  setState(() {
                                                    height = 1;
                                                  });
                                                });
                                                setState(() {
                                                  isFavorite == null
                                                      ? isFavorite = true
                                                      : isFavorite = null;
                                                });
                                                await moview
                                                    .idSetting(widget.id, 'tv')
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
                                                    type: 'tv',
                                                    title: widget.title,
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
                          tvShow.tagline == ""
                              ? Container()
                              : Text(
                                  "${tvShow.tagline}\n",
                                  style: GoogleFonts.dancingScript(
                                    fontSize: 18,
                                  ),
                                ),
                          tvShow.firstAirDate == ""
                              ? Container()
                              : MoviewRichText(
                                  title: "Release Date: ",
                                  description: tvShow.firstAirDate
                                      .replaceRange(4, 5, "/")
                                      .replaceRange(7, 8, "/"),
                                ),
                          MoviewRichText(
                            title: "Created by: ",
                            description: createdBy.join(", "),
                          ),
                          MoviewRichText(
                            title: "Overview: ",
                            description: tvShow.overview,
                          ),
                          MoviewRichText(
                            title: "\nSpoken Languages: ",
                            description: spokenLanguages.join(", "),
                          ),
                          MoviewRichText(
                            title: "Network: ",
                            description: network.join(", "),
                          ),
                          tvShow.productionCountries.isEmpty ? Container() : MoviewRichText(
                            title: "Production Country: ",
                            description: countries.join(", "),
                          ),
                          MoviewRichText(
                            title: "Total Episodes: ",
                            description: tvShow.numberOfEpisodes.toString(),
                          ),
                          tvShow.episodeRunTime.isEmpty
                              ? Container()
                              : MoviewRichText(
                                  title: "Episode Runtime: ",
                                  description:
                                      "${tvShow.episodeRunTime[0].toString()} minutes",
                                ),
                          Text(
                            "\nSeasons:",
                            style: GoogleFonts.merriweather(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3.7,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: tvShow.numberOfSeasons,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var season = tvShow.seasons[index];
                                return Align(
                                  child: PhysicalModel(
                                    color: Colors.transparent,
                                    elevation: 5,
                                    borderRadius: BorderRadius.circular(10),
                                    shadowColor: Colors.black,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      width:
                                          MediaQuery.of(context).size.width / 3,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF2A3155),
                                            Color(0xFF1F2339),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "https://image.tmdb.org/t/p/w500${season.posterPath}",
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, url, progress) {
                                                return Shimmer.fromColors(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            6,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            4,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  baseColor: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  highlightColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                );
                                              },
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Iconsax.danger5),
                                              fadeInDuration: Duration(
                                                milliseconds: 500,
                                              ),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AutoSizeText(
                                                  "${season.seasonNumber}. ${season.name}",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      GoogleFonts.merriweather(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize: 12,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  "${season.episodeCount} Episodes",
                                                  style:
                                                      GoogleFonts.merriweather(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                season.airDate == "" ? Container() : Text(
                                                  season.airDate
                                                      .replaceRange(4, 5, "/")
                                                      .replaceRange(7, 8, "/"),
                                                  style:
                                                      GoogleFonts.balooBhaijaan(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
