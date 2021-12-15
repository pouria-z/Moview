import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moview/screens/favorites_page.dart';
import 'package:moview/screens/intro/login_page.dart';
import 'package:moview/services.dart';
import 'package:moview/screens/genre/genres_page.dart';
import 'package:moview/screens/search_page.dart';
import 'package:moview/screens/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Connectivity connectivity = Connectivity();
  ConnectivityResult _connectivityResult = ConnectivityResult.wifi;
  late PersistentTabController _controller;


  // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    _controller = PersistentTabController(initialIndex: 0);
    connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        this._connectivityResult = result;
      });
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      moview.getUser();
      moview.hasUserLogged(context);
    });

    ///here
    // firebaseMessaging.getToken().then((value) {
    //   print(value);
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    //   print("message recieved");
    //   print(event.notification!.body);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print('Message clicked!');
    // });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return _connectivityResult == ConnectivityResult.none
            ? Scaffold(
              body: Center(
                  child: Text(
                      "No Network Connection. Please check your connection."),
                ),
            )
            : moview.showBottom == true
                ? PersistentTabView(
                    context,
                    confineInSafeArea: true,
                    screens: [
                      GenresPage(),
                      SearchPage(),
                      ProfilePage(
                        email: moview.email,
                        password: moview.password,
                        username: moview.username,
                      ),
                      FavoritesPage(),
                    ],
                    controller: _controller,
                    items: [
                      PersistentBottomNavBarItem(
                        icon: Icon(Icons.grid_view),
                        activeColorPrimary: Theme.of(context).accentColor,
                        activeColorSecondary: Colors.white,
                        inactiveColorPrimary: Colors.grey,
                      ),
                      PersistentBottomNavBarItem(
                        icon: Icon(Icons.search_rounded),
                        activeColorPrimary: Theme.of(context).accentColor,
                        activeColorSecondary: Colors.white,
                        inactiveColorPrimary: Colors.grey,
                      ),
                      PersistentBottomNavBarItem(
                        onPressed: (ctx) {
                          moview.hasUserLogged(context);
                          _controller.jumpToTab(2);
                        },
                        icon: Icon(Icons.person),
                        activeColorPrimary: Theme.of(context).accentColor,
                        activeColorSecondary: Colors.white,
                        inactiveColorPrimary: Colors.grey,
                      ),
                      PersistentBottomNavBarItem(
                        icon: Icon(Icons.favorite_border_rounded),
                        activeColorPrimary: Theme.of(context).accentColor,
                        activeColorSecondary: Colors.white,
                        inactiveColorPrimary: Colors.grey,
                      ),
                    ],
                    popActionScreens: PopActionScreensType.all,
                    itemAnimationProperties: ItemAnimationProperties(
                      duration: Duration(milliseconds: 450),
                      curve: Curves.easeInOutQuart,
                    ),
                    screenTransitionAnimation: ScreenTransitionAnimation(
                      animateTabTransition: true,
                      duration: Duration(milliseconds: 450),
                      curve: Curves.easeInOutQuart,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    hideNavigationBarWhenKeyboardShows: true,
                    navBarStyle: NavBarStyle.style3,
                  )
                : LoginPage();
      },
    );
  }
}
