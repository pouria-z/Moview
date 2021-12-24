import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Iconsax.info_circle),
            title: Text("About Moview"),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return AboutDeveloper();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Iconsax.copyright),
            title: Text("Licenses"),
            onTap: () {
              licensePage(context);
            },
          ),
        ],
      ),
    );
  }
}

class AboutDeveloper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Moview"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Center(
          child: ListView(
            children: [
              Text(
                "\nHi my name is Pouria Zeinalzadeh and I'm the developer of Moview app and "
                "have built this app from scratch.\n\nThe main reason I developed Moview "
                    "is for my Final Bachelor Project. I'm ${DateTime.now().year - 1999} and I'm majoring in "
                    "Computer Engineering at West Tehran Azad University and I will be graduated "
                    "by the end of spring 2022.\n\nThe app is written with Flutter framework and Dart "
                "programming language and for the backend service, I used Parse framework for authentication and database, "
                "and The Movie Database (TMDB) for API service.",
                style: GoogleFonts.roboto(),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 25,
              ),
              Divider(),
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Assistant Professor:",
                  style: GoogleFonts.robotoSlab(
                    color: Colors.white70,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                    "\nDr. Parisa Daneshjoo,\nHead of Department,"
                    " Computer engineering,\nWest Tehran Azad University,"
                    "\nTehran, Iran.",
                    style: GoogleFonts.robotoSlab()),
              ),
              SizedBox(
                height: 25,
              ),
              Divider(),
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Contact Info:",
                  style: GoogleFonts.robotoSlab(
                    color: Colors.white70,
                  ),
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 50,
                    ),
                    Text(
                      "Assistant Professor: ",
                      style: GoogleFonts.roboto(
                          color: Colors.white54, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        var url = "mailto:daneshjoo.p@wtiau.ac.ir";
                        launch(url);
                      },
                      child: Text(
                        "daneshjoo.p@wtiau.ac.ir",
                        style: GoogleFonts.roboto(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 50,
                    ),
                    Text(
                      "Student: ",
                      style: GoogleFonts.roboto(
                          color: Colors.white54, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        var url = "mailto:pouria.zeinalzadeh@gmail.com";
                        launch(url);
                      },
                      child: Text(
                        "pouria.zeinalzadeh@gmail.com",
                        style: GoogleFonts.roboto(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Website: ",
                      style: GoogleFonts.roboto(
                          color: Colors.white54, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        var url = "https://pouriazeinalzadeh.web.app";
                        launch(url);
                      },
                      child: Text(
                        "pouriazeinalzadeh.web.app",
                        style: GoogleFonts.roboto(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

licensePage(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Theme(
        data: ThemeData.dark().copyWith(
          cardColor: Color(0xFF161B2D),
          colorScheme: ColorScheme.dark().copyWith(
            secondary: Colors.orange.shade700,
            surface: Color(0xFF1C213B),
          ),
        ),
        child: LicensePage(
          applicationVersion: "1.0.0",
          applicationName: "Moview",
          applicationLegalese:
              "© Copyright ${DateTime.now().year} Pouria Zeinalzadeh Dallali. All rights reserved.",
        ),
      );
    },
  );
}
