import 'package:flutter/material.dart';
import 'package:moview/widgets.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (moview.favoriteListIsLoading == false) {
        setState(() {
          moview.favoritesList();
        });
      } else {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                moview.favoritesList();
              });
            },
            elevation: 7,
            child: Icon(Icons.refresh_rounded),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              moview.timeOutException == true
                  ? TimeOutWidget(
                      function: () {
                        setState(() {
                          moview.favoritesList();
                        });
                      },
                    )
                  : moview.favoriteNumbers == null
                      ? Center(child: CircularProgressIndicator())
                      : moview.favoriteNumbers == 0
                          ? Center(child: Text("no data!"))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: moview.dbMediaNameList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Text(moview.dbFavoriteTypeList[index]
                                      .toString()),
                                  title: Text(
                                      moview.dbMediaNameList[index].toString()),
                                  trailing:
                                      Text(moview.dbYearList[index].toString()),
                                  onTap: () {
                                    moview.tvShowName = null;
                                    moview.movieName = null;
                                    moview.getTvShowDetailsIsLoading = true;
                                    moview.getMovieDetailsIsLoading = true;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => moview
                                                          .dbFavoriteTypeList[
                                                      index] ==
                                                  'tv'
                                              ? TVShowDetails(
                                                  id: moview
                                                      .dbMediaIdList[index])
                                              : MovieDetails(
                                                  id: moview
                                                      .dbMediaIdList[index]),
                                        ));
                                  },
                                );
                              },
                            ),
            ],
          ),
        );
      },
    );
  }
}
