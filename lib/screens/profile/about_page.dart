import 'package:flutter/material.dart';

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
            title: Text("About developer"),
          ),
          ListTile(
            title: Text("Licenses"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
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
                            "© Copyright 2021 Pouria Zeinalzadeh. All rights reserved.",
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
