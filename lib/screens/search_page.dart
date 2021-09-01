import 'package:flutter/material.dart';
import 'package:moview/widgets.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var input;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    moview.searchPage = 1;
    moview.timeOutException = false;
    _scrollController.addListener(() async {
      print("scroller is moving");
      if (moview.searchNameList.isNotEmpty &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          moview.searchPage <= moview.searchTotalPages) {
        moview.searchPage = moview.searchPage + 1;
        print(moview.searchPage);
        setState(() {
          moview.getSearchResults();
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
          body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    input = value;
                    //moview.searchMediaTypeList.clear();
                  },
                  decoration: InputDecoration(
                      hintText: "Movie name, TV Show name...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        moview.searchPage = 1;
                        moview.searchNameList.clear();
                        moview.searchIdList.clear();
                        moview.searchMediaTypeList.clear();
                        moview.searchInput = input;
                        moview.getSearchResults();
                      });
                    },
                    child: Text("Search")),
                moview.timeOutException == true
                    ? TimeOutWidget(
                        function: () {
                          setState(() {
                            moview.getSearchResults();
                          });
                        },
                      )
                    : moview.searchNameList.isEmpty &&
                            moview.isSearching == true
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : moview.searchNameList.isEmpty
                            ? Text("no result")
                            : Expanded(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 2,
                                          mainAxisExtent: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              3,
                                        ),
                                        physics: BouncingScrollPhysics(),
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        itemCount: moview.searchNameList.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            splashColor: Color(0xFF36367C),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            onTap: () {
                                              moview.tvShowName = null;
                                              moview.movieName = null;
                                              moview.getTvShowDetailsIsLoading =
                                                  true;
                                              moview.getMovieDetailsIsLoading =
                                                  true;
                                              if (moview.tvShowName != null) {
                                                moview.tvShowName = null;
                                              }
                                              if (moview.searchMediaTypeList[
                                                      index] ==
                                                  'tv') {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return TVShowDetails(
                                                      id: moview
                                                          .searchIdList[index],
                                                    );
                                                  },
                                                ));
                                              } else if (moview
                                                          .searchMediaTypeList[
                                                      index] ==
                                                  'movie') {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return MovieDetails(
                                                        id: moview.searchIdList[
                                                            index]);
                                                  },
                                                ));
                                              }
                                            },
                                            child: MoviewCard(
                                              imageUrl: moview
                                                  .searchPosterUrlList[index],
                                              title:
                                                  moview.searchNameList[index],
                                              rating: moview
                                                  .searchRateList[index]
                                                  .toDouble()
                                                  .toString(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    moview.isLoadingMore == false
                                        ? Container()
                                        : SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                15,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 1.2,
                                              ),
                                            ),
                                          ),
                                  ],
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
