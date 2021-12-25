import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              child: Stack(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "dancingScript",
                          style: GoogleFonts.dancingScript(
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: "greatVibes",
                          style: GoogleFonts.greatVibes(
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: "comfortaa",
                          style: GoogleFonts.comfortaa(
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: "robotoSlab",
                          style: GoogleFonts.robotoSlab(
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: "josefinSans",
                          style: GoogleFonts.josefinSans(
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: "libreBaskerville",
                          style: GoogleFonts.libreBaskerville(
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: "balooBhaijaan",
                          style: GoogleFonts.balooBhaijaan(
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: "merriweather",
                          style: GoogleFonts.merriweather(
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: "exo2",
                          style: GoogleFonts.exo2(
                            color: Colors.transparent,
                          ),
                        ),
                        TextSpan(
                          text: "ubuntu",
                          style: GoogleFonts.ubuntu(
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(child: CircularProgressIndicator()),
                ],
              ),
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
