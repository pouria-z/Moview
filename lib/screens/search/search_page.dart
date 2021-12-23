import 'package:flutter/material.dart';
import 'package:moview/models/search_model.dart';
import 'package:moview/screens/search/search_results_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            leading: BackButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.of(context).pop();
              },
            ),
            actions: [
              _textEditingController.text.isEmpty
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          _textEditingController.clear();
                        });
                      },
                      icon: Icon(Icons.clear),
                      tooltip: "Clear",
                    ),
            ],
            title: TextField(
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.search,
              onChanged: (value) async {
                setState(() {});
                if (value.trim().length >= 3) {
                  moview.searchMoviesModel = moview
                      .getSearchMovies(_textEditingController.text.trim());
                }
              },
              onSubmitted: (value) {
                if (_textEditingController.text.isEmpty) {
                  moviewSnackBar(context,
                      response: "Please enter Movie/TV Show name");
                } else {
                  fadeNavigator(
                    context,
                    newPage: SearchResultsPage(
                      searchInput: _textEditingController.text,
                    ),
                    duration: 500,
                  );
                }
              },
              autofocus: true,
              controller: _textEditingController,
              decoration: InputDecoration.collapsed(
                hintText: "Movie name, TV Show name...",
              ),
            ),
          ),
          body: FutureBuilder<SearchMoviesModel>(
            future: moview.searchMoviesModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (_textEditingController.text.length < 3) {
                return Center(
                  child: Text(
                    "Type something",
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }
              if (snapshot.hasError) {
                return TimeOutWidget(onRefresh: () {
                  setState(() {
                    moview.searchMoviesModel =
                        moview.getSearchMovies(_textEditingController.text);
                  });
                });
              }
              if (snapshot.data!.results.isEmpty) {
                return Center(
                  child: Text(
                    "Oops! Nothing found :(",
                    style: TextStyle(color: Colors.white54),
                  ),
                );
              }
              return ListView(
                physics: BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  suggestionCardGridView(
                    context,
                    data: snapshot.data!.results,
                    type: 'movie',
                  ),
                  MaterialButton(
                    onPressed: () {
                      fadeNavigator(
                        context,
                        newPage: SearchResultsPage(
                          searchInput: _textEditingController.text,
                        ),
                        duration: 500,
                      );
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Text(
                      "see all results for movies and tv shows",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
