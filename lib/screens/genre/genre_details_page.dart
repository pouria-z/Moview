import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
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
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 2,
                              mainAxisExtent:
                                  MediaQuery.of(context).size.height / 3,
                            ),
                            physics: BouncingScrollPhysics(),
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: moview.genreResultNameList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                splashColor: Color(0xFF36367C),
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  moview.movieName = null;
                                  moview.tvShowName = null;
                                  moview.getMovieDetailsIsLoading = true;
                                  moview.getTvShowDetailsIsLoading = true;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => widget.type ==
                                                'movie'
                                            ? MovieDetails(
                                                id: moview
                                                    .genreResultIdList[index],
                                              )
                                            : TVShowDetails(
                                                id: moview
                                                    .genreResultIdList[index],
                                              ),
                                      ));
                                },
                                child: MoviewCard(
                                  imageUrl:
                                      moview.genreResultPosterUrlList[index],
                                  title: moview.genreResultNameList[index],
                                  rating: moview.genreResultRateList[index]
                                      .toDouble()
                                      .toString(),
                                ),
                              );
                            },
                          ),
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
