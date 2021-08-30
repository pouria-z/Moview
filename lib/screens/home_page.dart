import 'package:flutter/material.dart';
import 'package:moview/screens/favorites_page.dart';
import 'package:moview/services.dart';
import 'package:moview/screens/genre/genres_page.dart';
import 'package:moview/screens/search_page.dart';
import 'package:moview/screens/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var tabController;
  Connectivity connectivity = Connectivity();
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        this._connectivityResult = result;
      });
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      moview.getUser();
    });
    tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Moview"),
            elevation: 0,
          ),
          body: _connectivityResult == ConnectivityResult.none
              ? Center(
                  child: Text("No Network Connection. Please check your connection."),
                )
              : TabBarView(
                  children: [
                    GenresPage(),
                    SearchPage(),
                    ProfilePage(
                      username: moview.username,
                      email: moview.email,
                      password: moview.password,
                    ),
                    FavoritesPage(),
                  ],
                  controller: tabController,
                ),
          bottomNavigationBar: _connectivityResult == ConnectivityResult.none
              ? null
              : Material(
                  color: Theme.of(context).primaryColor,
                  child: TabBar(
                    controller: tabController,
                    isScrollable: false,
                    tabs: [
                      Tab(
                        child: Text("Genres"),
                        icon: Icon(Icons.grid_view),
                      ),
                      Tab(
                        child: Text("Search"),
                        icon: Icon(Icons.search_rounded),
                      ),
                      Tab(
                        child: Text("Profile"),
                        icon: Icon(Icons.person),
                      ),
                      Tab(
                        child: Text("Favorites"),
                        icon: Icon(Icons.favorite_border_rounded),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
