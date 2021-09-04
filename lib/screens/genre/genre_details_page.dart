import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    print("genre id: ${widget.id}");
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      moview.type = widget.type;
      moview.genreMovieId = widget.id;
      moview.genreResultPage = widget.pageNumber;
      await moview.getGenreResultList();
    });
    _scrollController.addListener(() async {
      print("scroller is moving");
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          moview.genreResultPage <= moview.genreResultTotalPages) {
        print("if condition is true");
        moview.genreResultPage = moview.genreResultPage + 1;
        setState(() {
          moview.getGenreResultList();
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
                    curve: Curves.fastOutSlowIn);
              },
              child: Text(widget.type == 'movie'
                  ? "Movie | " + widget.name
                  : "TV Show | " + widget.name),
            ),
          ),
          body: moview.timeOutException == true
              ? TimeOutWidget(
                  function: () {
                    setState(() {
                      moview.getGenreResultList().whenComplete(() =>
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent));
                    });
                  },
                )
              : moview.getGenreResultListIsLoading == true &&
                      moview.genreResultNameList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        moviewGridView(
                          context,
                          _scrollController,
                          widget.type,
                          moview.genreResultIdList,
                          moview.genreResultPosterUrlList,
                          moview.genreResultNameList,
                          moview.genreResultRateList,
                          moview.genreResultNameList.length,
                        ),
                        moview.genreResultListIsLoadingMore == false
                            ? Container()
                            : CircularProgressIndicator(
                                strokeWidth: 1.2,
                              ),
                      ],
                    ),
        );
      },
    );
  }
}
