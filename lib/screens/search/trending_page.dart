import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moview/models/trending_model.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:moview/screens/search/search_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

class TrendingPage extends StatefulWidget {
  const TrendingPage({Key? key}) : super(key: key);

  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  ScrollController _scrollController = ScrollController();
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      moview.trendingMoviesModel = moview.getTrendingMovies();
      moview.trendingTvShowsModel = moview.getTrendingTvShows();
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
            title: "Search",
            action: IconButton(
              onPressed: () {
                sharedAxisNavigator(
                  context,
                  newPage: SearchPage(),
                  duration: 500,
                );
              },
              icon: Icon(Iconsax.search_normal_1),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Trending Movies This Week",
                      style: GoogleFonts.josefinSans(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder<TrendingMoviesModel>(
                    future: moview.trendingMoviesModel,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2.7,
                          child: TrendingLoading(),
                        );
                      }
                      if (snapshot.hasError) {
                        print("*** error: ${snapshot.error.toString()}");
                        return TimeOutWidget(
                          onRefresh: () {
                            setState(() {
                              moview.trendingMoviesModel =
                                  moview.getTrendingMovies();
                            });
                          },
                        );
                      } else {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2.7,
                          child: ListView.builder(
                            itemCount: snapshot.data!.results.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var trendingMovie = snapshot.data!.results[index];
                              return InkWell(
                                splashColor: Color(0xFF36367C),
                                borderRadius: BorderRadius.circular(7),
                                onTap: () {
                                  animationTransition(
                                    context,
                                    MovieDetails(
                                      id: trendingMovie.id,
                                      title: trendingMovie.title,
                                      posterPath: trendingMovie.posterPath,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: MoviewCard(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    imageUrl: trendingMovie.posterPath,
                                    title: trendingMovie.title,
                                    rating: trendingMovie.voteAverage,
                                    id: trendingMovie.id,
                                    year: trendingMovie.releaseDate,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Trending TV Shows This Week",
                      style: GoogleFonts.josefinSans(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  FutureBuilder<TrendingTvShowsModel>(
                    future: moview.trendingTvShowsModel,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2.7,
                          child: TrendingLoading(),
                        );
                      }
                      if (snapshot.hasError) {
                        print("*** error: ${snapshot.error.toString()}");
                        return TimeOutWidget(
                          onRefresh: () {
                            setState(() {
                              moview.trendingMoviesModel =
                                  moview.getTrendingMovies();
                            });
                          },
                        );
                      } else {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 2.7,
                          child: ListView.builder(
                            itemCount: snapshot.data!.results.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var trendingTvShow =
                                  snapshot.data!.results[index];
                              return InkWell(
                                splashColor: Color(0xFF36367C),
                                borderRadius: BorderRadius.circular(7),
                                onTap: () {
                                  animationTransition(
                                    context,
                                    TVShowDetails(
                                      id: trendingTvShow.id,
                                      title: trendingTvShow.title,
                                      posterPath: trendingTvShow.posterPath,
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 2),
                                  child: MoviewCard(
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    imageUrl: trendingTvShow.posterPath,
                                    title: trendingTvShow.title,
                                    rating: trendingTvShow.voteAverage,
                                    id: trendingTvShow.id,
                                    year: trendingTvShow.releaseDate,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
