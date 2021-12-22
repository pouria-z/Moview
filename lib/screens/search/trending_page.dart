import 'package:flutter/material.dart';
import 'package:moview/models/trending_model.dart';
import 'package:moview/screens/search/search_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPage(),
                  ),
                );
              },
              icon: Icon(Icons.search),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  Text("Trending Movies This Week"),
                  FutureBuilder<TrendingMoviesModel>(
                    future: moview.trendingMoviesModel,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return TrendingLoading();
                      }
                      if (snapshot.hasError) {
                        print("*** error: ${snapshot.error.toString()}");
                        TimeOutWidget(
                          onRefresh: () {
                            setState(() {
                              moview.trendingMoviesModel =
                                  moview.getTrendingMovies();
                            });
                          },
                        );
                      }
                      var trendingMovie = snapshot.data!.results;
                      return Expanded(
                        child: moviewGridView(
                          context,
                          moview,
                          height: MediaQuery.of(context).size.height / 3,
                          mainAxisExtent: MediaQuery.of(context).size.width / 2,
                          itemsInRow: 1,
                          scrollDirection: Axis.horizontal,
                          scrollController: _scrollController,
                          data: trendingMovie,
                          type: 'movie',
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Trending TV Shows This Week"),
                  FutureBuilder<TrendingTvShowsModel>(
                    future: moview.trendingTvShowsModel,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return TrendingLoading();
                      }
                      if (snapshot.hasError) {
                        print("*** error: ${snapshot.error.toString()}");
                        TimeOutWidget(
                          onRefresh: () {
                            setState(() {
                              moview.trendingMoviesModel =
                                  moview.getTrendingMovies();
                            });
                          },
                        );
                      }
                      var trendingTvShow = snapshot.data!.results;
                      return Expanded(
                        child: moviewGridView(
                          context,
                          moview,
                          height: MediaQuery.of(context).size.height / 3,
                          mainAxisExtent: MediaQuery.of(context).size.width / 2,
                          itemsInRow: 1,
                          scrollDirection: Axis.horizontal,
                          scrollController: _scrollController,
                          data: trendingTvShow,
                          type: 'tv',
                        ),
                      );
                    },
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
