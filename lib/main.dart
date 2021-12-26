import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moview/key.dart';
import 'package:moview/screens/splash_screen.dart';
import 'package:moview/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    autoSendSessionId: true,
  );

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF161B2D),
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Color(0xFF161B2D),
    ),
  );

  runApp(MoviewApp());
}

class MoviewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Moview(),
      child: MaterialApp(
        title: "Moview",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Color(0xFF161B2D),
          dialogBackgroundColor: Color(0xFF161B2D),
          primaryColor: Color(0xFF1C213B),
          colorScheme: ColorScheme.dark().copyWith(
            secondary: Colors.orange.shade700,
          ),
          textTheme: GoogleFonts.comfortaaTextTheme().copyWith(
            bodyText1: GoogleFonts.comfortaa(color: Colors.white),
            caption: GoogleFonts.comfortaa(color: Colors.white),
            subtitle1: GoogleFonts.roboto(color: Colors.white),
            subtitle2: GoogleFonts.comfortaa(color: Colors.white),
            bodyText2: GoogleFonts.comfortaa(color: Colors.white),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
