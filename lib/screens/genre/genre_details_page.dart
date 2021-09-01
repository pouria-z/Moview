import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
            title: Text(widget.type == 'movie'
                ? "Movie | " + widget.name
                : "TV Show | " + widget.name),
          ),
          body: moview.timeOutException == true
              ? TimeOutWidget(
                  function: () {
                    setState(() {
                      moview.getGenreResultList();
                    });
                  },
                )
              : moview.getGenreResultListIsLoading == true &&
                      moview.genreResultNameList.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Column(
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
                                  child: Card(
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    elevation: 5,
                                    shadowColor: Colors.black,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: moview
                                              .genreResultPosterUrlList[index],
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Shimmer.fromColors(
                                                  child: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            4.1,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            3,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  baseColor: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  highlightColor:
                                                      Color(0xFF383838)),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          fadeInDuration: Duration(
                                            milliseconds: 500,
                                          ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4.1,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                        ),
                                        Text(
                                          moview.genreResultNameList[index],
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(moview.genreResultRateList[index]
                                            .toString()),
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
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.2,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
