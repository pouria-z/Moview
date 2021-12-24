import 'package:flutter/material.dart';
import 'package:moview/models/search_model.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchResultsPage extends StatefulWidget {
  final String searchInput;

  const SearchResultsPage({required this.searchInput});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<Moview>(context).hasUserLogged(context);
    });
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Results for ${widget.searchInput}"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orangeAccent,
          labelColor: Colors.orangeAccent,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              text: "Movies",
            ),
            Tab(
              text: "TV Shows",
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          SearchMoviesResultsPage(
            searchInput: widget.searchInput,
          ),
          SearchTvShowsResultsPage(
            searchInput: widget.searchInput,
          ),
        ],
        controller: _tabController,
      ),
    );
  }
}

///Movies Tab
class SearchMoviesResultsPage extends StatefulWidget {
  final String searchInput;
  static final RefreshController refreshController = RefreshController();

  const SearchMoviesResultsPage({required this.searchInput});

  @override
  _SearchMoviesResultsPageState createState() =>
      _SearchMoviesResultsPageState();
}

class _SearchMoviesResultsPageState extends State<SearchMoviesResultsPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  List moviesData = List.generate(20, (index) => null);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var moview = Provider.of<Moview>(context, listen: false);
      moview.searchMoviesPage = 1;
      moview.searchMoviesModel = moview.getSearchMovies(widget.searchInput);
    });
  }

  Future loadMore() async {
    var moview = Provider.of<Moview>(context, listen: false);
    if (moview.searchMoviesPage >= moview.searchMoviesTotalPages) {
      SearchMoviesResultsPage.refreshController.loadNoData();
    } else {
      moview.searchMoviesPage++;
      final moviesResponse = await moview.getSearchMovies(widget.searchInput);
      moviesData.addAll(moviesResponse.results);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          body: SmartRefresher(
            controller: SearchMoviesResultsPage.refreshController,
            enablePullUp: true,
            enablePullDown: false,
            onLoading: () async {
              await loadMore();
              SearchMoviesResultsPage.refreshController.loadComplete();
            },
            child: FutureBuilder<SearchMoviesModel>(
              future: moview.searchMoviesModel,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.results.isEmpty) {
                  return Center(
                    child: Text(
                      "There is no result for ${widget.searchInput} in movies!",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                } else {
                  moviesData = snapshot.data!.results;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: moviewGridView(
                      context,
                      moview,
                      height: MediaQuery.of(context).size.height / 3,
                      mainAxisExtent: MediaQuery.of(context).size.height / 2.7,
                      itemsInRow: 2,
                      scrollDirection: Axis.vertical,
                      scrollController: _scrollController,
                      data: moviesData,
                      type: 'movie',
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

///TVShows Tab
class SearchTvShowsResultsPage extends StatefulWidget {
  final String searchInput;
  static final RefreshController refreshController = RefreshController();

  const SearchTvShowsResultsPage({required this.searchInput});

  @override
  _SearchTvShowsResultsPageState createState() =>
      _SearchTvShowsResultsPageState();
}

class _SearchTvShowsResultsPageState extends State<SearchTvShowsResultsPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  List tvShowsData = List.generate(20, (index) => null);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var moview = Provider.of<Moview>(context, listen: false);
      moview.searchTvShowsPage = 1;
      moview.searchTvShowsModel = moview.getSearchTvShows(widget.searchInput);
    });
  }

  Future loadMore() async {
    var moview = Provider.of<Moview>(context, listen: false);
    if (moview.searchTvShowsPage >= moview.searchTvShowsTotalPages) {
      SearchTvShowsResultsPage.refreshController.loadNoData();
    } else {
      moview.searchTvShowsPage++;
      final tvShowsResponse = await moview.getSearchTvShows(widget.searchInput);
      tvShowsData.addAll(tvShowsResponse.results);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          body: SmartRefresher(
            controller: SearchTvShowsResultsPage.refreshController,
            enablePullUp: true,
            enablePullDown: false,
            onLoading: () async {
              await loadMore();
              SearchTvShowsResultsPage.refreshController.loadComplete();
            },
            child: FutureBuilder<SearchTvShowsModel>(
              future: moview.searchTvShowsModel,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.results.isEmpty) {
                  return Center(
                    child: Text(
                      "There is no result for ${widget.searchInput} in TV Shows!",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                } else {
                  tvShowsData = snapshot.data!.results;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: moviewGridView(
                      context,
                      moview,
                      height: MediaQuery.of(context).size.height / 3,
                      mainAxisExtent: MediaQuery.of(context).size.height / 2.7,
                      itemsInRow: 2,
                      scrollDirection: Axis.vertical,
                      scrollController: _scrollController,
                      data: tvShowsData,
                      type: 'tv',
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
