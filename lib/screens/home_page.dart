import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moview/screens/favorites_page.dart';
import 'package:moview/screens/genre/genres_page.dart';
import 'package:moview/screens/intro/login_page.dart';
import 'package:moview/screens/profile/profile_page.dart';
import 'package:moview/screens/search/trending_page.dart';
import 'package:moview/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Connectivity connectivity = Connectivity();
  ConnectivityResult _connectivityResult = ConnectivityResult.wifi;
  late PersistentTabController _controller;

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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).primaryColor,
          statusBarColor: Theme.of(context).primaryColor,
          systemNavigationBarDividerColor: Theme.of(context).primaryColor,
        ),
      );
      await moview.getImages();
      moview.getUser();
      moview.hasUserLogged(context);
    });
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
                      TrendingPage(),
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
                        icon: Icon(Iconsax.grid_2),
                        activeColorPrimary:
                            Theme.of(context).colorScheme.secondary,
                        activeColorSecondary:
                            Theme.of(context).colorScheme.secondary,
                        inactiveColorPrimary: Colors.grey,
                      ),
                      PersistentBottomNavBarItem(
                        icon: Icon(Iconsax.search_normal),
                        activeColorPrimary:
                            Theme.of(context).colorScheme.secondary,
                        activeColorSecondary:
                            Theme.of(context).colorScheme.secondary,
                        inactiveColorPrimary: Colors.grey,
                      ),
                      PersistentBottomNavBarItem(
                        onPressed: (ctx) {
                          moview.hasUserLogged(context);
                          _controller.jumpToTab(2);
                        },
                        icon: Icon(Iconsax.user),
                        activeColorPrimary:
                            Theme.of(context).colorScheme.secondary,
                        activeColorSecondary:
                            Theme.of(context).colorScheme.secondary,
                        inactiveColorPrimary: Colors.grey,
                      ),
                      PersistentBottomNavBarItem(
                        icon: Icon(Iconsax.heart),
                        activeColorPrimary:
                            Theme.of(context).colorScheme.secondary,
                        activeColorSecondary:
                            Theme.of(context).colorScheme.secondary,
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
