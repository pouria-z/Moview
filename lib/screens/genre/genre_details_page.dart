import 'package:flutter/material.dart';
import 'package:moview/models/genre_result_model.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GenreDetails extends StatefulWidget {
  final type;
  final id;
  final name;

  const GenreDetails({
    Key? key,
    required this.type,
    required this.id,
    required this.name,
  }) : super(key: key);

  static final RefreshController refreshController =
  RefreshController(initialRefresh: true);

  @override
  _GenreDetailsState createState() => _GenreDetailsState();
}

class _GenreDetailsState extends State<GenreDetails> {
  ScrollController _scrollController = ScrollController();

  List<Result> data = [];
  bool enablePullUp = false;

  Future getData({bool isRefresh = false}) async {
    var moview = Provider.of<Moview>(context, listen: false);
    if (isRefresh) {
      moview.genreResultPage = 1;
    } else {
      if (moview.genreResultPage >= moview.genreResultTotalPages) {
        GenreDetails.refreshController.loadNoData();
      }
    }

    final response = await moview.getGenreResult(widget.type, widget.id);

    if (isRefresh) {
      data = response.results;
    } else {
      data.addAll(response.results);
    }
    moview.genreResultPage++;
    if (moview.genreResultPage > 1) {
      setState(() {
        enablePullUp = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () {
                _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: Duration(milliseconds: 900),
                  curve: Curves.fastOutSlowIn,
                );
              },
              child: Text(widget.type == 'movie'
                  ? "Movie | " + widget.name
                  : "TV Show | " + widget.name),
            ),
          ),
          body:SmartRefresher(
                  controller: GenreDetails.refreshController,
                  enablePullUp: enablePullUp,
                  onRefresh: () async {
                    await getData(isRefresh: true);
                    GenreDetails.refreshController.refreshCompleted();
                  },
                  onLoading: () async {
                    await getData();
                    GenreDetails.refreshController.loadComplete();
                  },
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 2,
                      mainAxisExtent: MediaQuery.of(context).size.height / 3,
                    ),
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final genreResultModel = data[index];
                      return InkWell(
                        splashColor: Color(0xFF36367C),
                        borderRadius: BorderRadius.circular(5),
                        onTap: () {
                          moview.tvShowName = null;
                          moview.movieName = null;
                          moview.getTvShowDetailsIsLoading = true;
                          moview.getMovieDetailsIsLoading = true;
                          if (widget.type.runtimeType == String
                              ? widget.type == 'tv'
                              : widget.type[index] == 'tv') {
                            animationTransition(
                              context,
                              TVShowDetails(
                                id: genreResultModel.id,
                                tvShowName: genreResultModel.title,
                                tvShowPosterUrl: genreResultModel.posterPath,
                              ),
                            );
                          } else if (widget.type.runtimeType == String
                              ? widget.type == 'movie'
                              : widget.type[index] == 'movie') {
                            animationTransition(
                              context,
                              MovieDetails(
                                id: genreResultModel.id,
                                movieName: genreResultModel.title,
                                moviePosterUrl: genreResultModel.posterPath,
                              ),
                            );
                          }
                        },
                        child: MoviewCard(
                          id: genreResultModel.id,
                          imageUrl: genreResultModel.posterPath,
                          title: genreResultModel.title,
                          rating:
                              genreResultModel.voteAverage.runtimeType == String
                                  ? genreResultModel.voteAverage
                                  : genreResultModel.voteAverage.toString(),
                        ),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }
}
