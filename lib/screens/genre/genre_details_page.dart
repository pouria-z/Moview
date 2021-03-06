import 'package:flutter/material.dart';
import 'package:moview/models/genre_result_model.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GenreDetails extends StatefulWidget {
  final type;
  final id;
  final name;
  static final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  const GenreDetails({
    Key? key,
    required this.type,
    required this.id,
    required this.name,
  }) : super(key: key);

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
      moview.hasUserLogged(context);
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
      moview.hasUserLogged(context);
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
            backgroundColor: Theme.of(context).primaryColor,
            title: GestureDetector(
              onTap: () {
                _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: Duration(milliseconds: 900),
                  curve: Curves.fastOutSlowIn,
                );
              },
              child: Text(
                widget.type == 'movie'
                    ? "Movie | " + widget.name
                    : "TV Show | " + widget.name,
              ),
            ),
          ),
          body: SmartRefresher(
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: moviewGridView(
                context,
                moview,
                height: MediaQuery.of(context).size.height / 3,
                mainAxisExtent: MediaQuery.of(context).size.height / 2.8,
                itemsInRow: 2,
                scrollDirection: Axis.vertical,
                scrollController: _scrollController,
                data: data,
                type: widget.type,
              ),
            ),
          ),
        );
      },
    );
  }
}
