import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moview/key.dart';
import 'package:moview/screens/intro/login_page.dart';
import 'package:moview/screens/home_page.dart';
import 'package:moview/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

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

  await isUserLoggedIn();

  runApp(
    MoviewApp(response: parseResponse),
  );
}

class MoviewApp extends StatelessWidget {
  const MoviewApp({this.response});

  final response;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Moview(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF212745),
          primaryColor: Color(0xFF1C213B),
          textTheme: GoogleFonts.comfortaaTextTheme().copyWith(
            bodyText1: GoogleFonts.comfortaa(color: Colors.white),
            caption: GoogleFonts.comfortaa(color: Colors.white),
            subtitle1: GoogleFonts.comfortaa(color: Colors.white),
            subtitle2: GoogleFonts.comfortaa(color: Colors.white),
            bodyText2: GoogleFonts.comfortaa(color: Colors.white),
          ),
        ),
        home: response?.success == null || !response!.success
            ? LoginPage()
            : HomePage(),
      ),
    );
  }
}
