import 'package:flutter/material.dart';
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

  @override
  void initState() {
    Provider.of<Moview>(context, listen: false).genreMovieNameList.clear();
    Provider.of<Moview>(context, listen: false).genreMovieIdList.clear();
    // if(input!=null){
    //   Provider.of<Moview>(context, listen: false).getSearchResults();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Moview"),
          ),
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
                      moview.searchNameList.clear();
                      moview.searchIdList.clear();
                      moview.searchInput = input;
                      moview.getSearchResults();
                    },
                    child: Text("Search")),
                moview.searchNameList.isEmpty
                    ? Text("no result")
                    : Expanded(
                      child: Column(
                          children: [
                            Expanded(
                              flex: 15,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: moview.count - moview.personCount,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Text(
                                        moview.searchIdList[index].toString()),
                                    title: Text(moview.searchNameList[index]),
                                    trailing:
                                        Text(moview.searchMediaTypeList[index]),
                                    onTap: () {
                                      moview.searchPage = 1;
                                      moview.tvShowGenreList.clear();
                                      moview.tvShowLanguagesList.clear();
                                      moview.tvShowCountryList.clear();
                                      //moview.getSearchResults();
                                      moview.tvShowRuntime = "";
                                      if (moview.tvShowName != null) {
                                        moview.tvShowName = null;
                                      }
                                      if (moview.searchMediaTypeList[index] ==
                                          'tv') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TVShowDetails(
                                                id: moview.searchIdList[index],
                                              ),
                                            ));
                                      } else if (moview
                                              .searchMediaTypeList[index] ==
                                          'movie') {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MovieDetails(
                                                  id: moview.searchIdList[index]),
                                            ));
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: moview.searchTotalPages,
                                itemBuilder: (context, index) {
                                  var i = index + 1;
                                  return TextButton(
                                      onPressed: () {
                                        moview.searchPage = i;
                                        moview.searchIdList.clear();
                                        moview.searchNameList.clear();
                                        moview.getSearchResults();
                                      },
                                      child: Text(i.toString()));
                                },
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
