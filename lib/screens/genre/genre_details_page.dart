import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:provider/provider.dart';

class GenreDetails extends StatefulWidget {
  final type;
  final id;
  final pageNumber;

  const GenreDetails(
      {Key? key,
      @required this.type,
      @required this.id,
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
    return Scaffold(body: SafeArea(
      child: Consumer<Moview>(
        builder: (context, value, child) {
          return moview.getGenreResultListIsLoading == true &&
                  moview.genreResultNameList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : moview.timeOutException == true
                  ? TimeOutWidget(
                      function: () {
                        setState(() {
                          moview.getGenreResultList();
                        });
                      },
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            physics: BouncingScrollPhysics(),
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: moview.genreResultNameList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
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
                                child: Container(
                                  child: Column(
                                    children: [
                                      Image.network(
                                        moview.genreResultPosterUrlList[index],
                                        height: 150,
                                        width: 150,
                                      ),
                                      Text(moview.genreResultNameList[index])
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        moview.genreResultListIsLoadingMore == false
                            ? Container()
                            : SizedBox(
                                height: MediaQuery.of(context).size.height / 15,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.2,
                                  ),
                                ),
                              ),
                      ],
                    );
        },
      ),
    ));
  }
}
