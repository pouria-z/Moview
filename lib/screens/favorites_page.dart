import 'package:flutter/material.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<Moview>(context, listen: false).favoriteNumbers = null;
      Provider.of<Moview>(context, listen: false).favoritesList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              moview.favoriteNumbers == null
                  ? Center(child: CircularProgressIndicator())
                  : moview.favoriteNumbers == 0
                      ? Center(child: Text("no data!"))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: moview.favoriteNumbers,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(moview.favoriteTvShowNameList[index]
                                  .toString()),
                              trailing: Text(moview
                                  .favoriteTvShowFirstAirList[index]
                                  .toString()),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TVShowDetails(
                                          id: moview
                                              .favoriteTvShowIdList[index]),
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
