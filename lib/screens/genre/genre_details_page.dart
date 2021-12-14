import 'package:flutter/material.dart';
import 'package:moview/models/genre_result_model.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

class GenreDetails extends StatefulWidget {
  final type;
  final id;
  final name;
  final pageNumber;

  const GenreDetails(
      {Key? key,
      @required this.type,
      @required this.id,
      @required this.name,
      @required this.pageNumber})
      : super(key: key);

  @override
  _GenreDetailsState createState() => _GenreDetailsState();
}

class _GenreDetailsState extends State<GenreDetails> {
  ScrollController _scrollController = ScrollController();

  int? totalPages;

  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    print("genre id: ${widget.id}");
    Future.delayed(Duration.zero, () async {
      moview.genreResultPage = widget.pageNumber;
      moview.genreResultModel = moview.getGenreResult(widget.type, widget.id);
    });
    _scrollController.addListener(() async {
      print("scroller is moving");
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          moview.genreResultPage <= moview.totalPages) {
        print("if condition is true");
        moview.genreResultPage = moview.genreResultPage + 1;
        setState(() {
          moview.getGenreResult(widget.type, widget.id);
        });
      }
    });
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
          body: moview.timedOut == true
              ? TimeOutWidget(
                  onRefresh: () {
                    setState(() {
                      moview.genreResultModel = moview
                          .getGenreResult(widget.type, widget.id)
                          .whenComplete(() => _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent));
                    });
                  },
                )
              : FutureBuilder(
                  future: moview.genreResultModel,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          moviewGridView2(context, widget.type,
                              _scrollController, moview),
                          moview.genreResultListIsLoadingMore == false
                              ? Container()
                              : CircularProgressIndicator(
                                  strokeWidth: 1.2,
                                ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      print("*** error: ${snapshot.stackTrace.toString()}");
                      TimeOutWidget(
                        onRefresh: () {
                          setState(() {
                            moview.genreResultModel =
                                moview.getGenreResult(widget.type, widget.id);
                          });
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
        );
      },
    );
  }
}
