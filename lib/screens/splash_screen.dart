import 'package:flutter/material.dart';
import 'package:moview/screens/home_page.dart';
import 'package:moview/screens/intro/login_page.dart';
import 'package:moview/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  ParseResponse? parseResponse;
  Future isUserLoggedIn() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    parseResponse =
    await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await isUserLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    moview.initialize = moview.initial();
    return FutureBuilder(
      future: moview.initialize,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (parseResponse?.success == null || !parseResponse!.success) {
            return LoginPage();
          } else {
            return HomePage();
          }
        }
      },
    );
  }
}
