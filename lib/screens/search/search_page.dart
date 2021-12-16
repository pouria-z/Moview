import 'package:flutter/material.dart';
import 'package:moview/models/trending.dart';
import 'package:moview/widgets.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';
import 'package:moview/screens/search/search_results_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _textEditingController = TextEditingController();
  bool showSuggestions = false;

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Scaffold(
      appBar: buildAppBar(context, "Search"),
      body: Consumer<Moview>(
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.search,
                  // onChanged: (value) async {
                  //   if (value.trim().length >= 3) {
                  //     setState(() {
                  //       moview.searchTypeInput =
                  //           _textEditingController.text.trim();
                  //       showSuggestions = true;
                  //     });
                  //     await moview.getSearchOnType();
                  //   } else {
                  //     setState(() {
                  //       moview.searchTypeNameList.clear();
                  //       moview.searchTypeRateList.clear();
                  //       showSuggestions = false;
                  //     });
                  //   }
                  // },
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
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    // await moview.getSearchMovies(_textEditingController.text);
                    // await moview.getSearchTvShows(_textEditingController.text);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultsPage(
                            searchInput: _textEditingController.text,
                          ),
                        ));
                  },
                  child: Text("Search"),
                  color: Colors.blue,
                ),
                FutureBuilder<TrendingMoviesModel>(
                  future: moview.getTrendingMovies(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text("movies");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                FutureBuilder<TrendingTvShowsModel>(
                  future: moview.getTrendingTvShows(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text("tv shows");
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
