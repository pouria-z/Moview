import 'package:flutter/material.dart';
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
      if (moview.isLoading == false){

          moview.favoritesList();

      } else {
        return null;
      }
    });
  }
  bool isLoading = false;

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
              moview.favoriteNumbers == null
                  ? Center(child: CircularProgressIndicator())
                  : moview.favoriteNumbers == 0
                      ? Center(child: Text("no data!"))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: moview.favoritePageNameList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Text(
                                  moview.dbFavoriteTypeList[index].toString()),
                              title: Text(moview.favoritePageNameList[index]
                                  .toString()),
                              trailing: Text(moview.favoritePageYearList[index]
                                  .toString()),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => moview
                                                  .dbFavoriteTypeList[index] ==
                                              'tv'
                                          ? TVShowDetails(
                                              id: moview
                                                  .favoritePageIdList[index])
                                          : MovieDetails(
                                              id: moview
                                                  .favoritePageIdList[index]),
                                    ));
                              },
                            );
                          },
                        )
            ],
          ),
        );
      },
    );
  }
}
