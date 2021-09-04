import 'package:flutter/material.dart';
import 'package:moview/widgets.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  var input;
  bool showSuggestions = false;
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

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
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: TextField(
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) async {
                    if (value.trim().length >= 3) {
                      setState(() {
                        moview.searchTypeInput =
                            _textEditingController.text.trim();
                        showSuggestions = true;
                      });
                      await moview.getSearchOnType();
                    } else {
                      setState(() {
                        moview.searchTypeNameList.clear();
                        moview.searchTypeRateList.clear();
                        showSuggestions = false;
                      });
                    }
                  },
                  controller: _textEditingController,
                  decoration: InputDecoration(
                      hintText: "Movie name, TV Show name...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _textEditingController.clear();
                            showSuggestions = false;
                          });
                        },
                      )),
                ),
              ),
              showSuggestions == true && moview.isSearchingOnType == false
                  ? Expanded(
                      flex: 15,
                      child: suggestionCardGridView(context),
                    )
                  : showSuggestions == true && moview.isSearchingOnType == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(),
              TextButton(
                  onPressed: () {
                    if (_textEditingController.text.trim().isNotEmpty) {
                      setState(() {
                        showSuggestions = false;
                        moview.searchPage = 1;
                        moview.searchNameList.clear();
                        moview.searchIdList.clear();
                        moview.searchMediaTypeList.clear();
                        moview.searchPosterUrlList.clear();
                        moview.searchRateList.clear();
                        moview.searchInput = _textEditingController.text.trim();
                        _textEditingController.clear();
                        moview.getSearchResults();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter movie/TV show name!'),
                        ),
                      );
                    }
                  },
                  child: Text("Search")),
              moview.timeOutException == true
                  ? TimeOutWidget(
                      function: () {
                        setState(() {
                          moview.getSearchResults().whenComplete(() =>
                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent));
                        });
                      },
                    )
                  : moview.searchNameList.isEmpty && moview.isSearching == true
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : moview.searchNameList.isEmpty
                          ? Text("no result")
                          : Expanded(
                              flex: showSuggestions == true ? 1 : 15,
                              child: Column(
                                children: [
                                  moviewGridView(
                                    context,
                                    _scrollController,
                                    moview.searchMediaTypeList,
                                    moview.searchIdList,
                                    moview.searchPosterUrlList,
                                    moview.searchNameList,
                                    moview.searchRateList,
                                    moview.searchNameList.length,
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
        );
      },
    );
  }
}
