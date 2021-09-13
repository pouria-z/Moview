import 'package:flutter/material.dart';
import 'package:moview/widgets.dart';
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
          appBar: buildAppBar(context, "Favorites"),
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
                          : moviewGridView(
                              context,
                              null,
                              moview.dbFavoriteTypeList,
                              moview.dbMediaIdList,
                              moview.dbMediaPosterList,
                              moview.dbMediaNameList,
                              moview.dbYearList,
                              moview.dbMediaNameList.length,
                            ),
            ],
          ),
        );
      },
    );
  }
}
