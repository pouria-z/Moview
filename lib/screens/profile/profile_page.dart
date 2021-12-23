import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moview/screens/profile/about_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String? email;
  final String? password;
  final String? username;

  const ProfilePage(
      {Key? key,
      required this.email,
      required this.password,
      required this.username})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      moview.email = widget.email;
      moview.username = widget.username;
      moview.password = widget.password;
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: buildAppBar(
            context,
            title: "Profile",
            action: Container(),
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          foregroundColor: Colors.white,
                          radius: 32,
                          child:
                              Text(widget.username.toString()[0].toUpperCase()),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          "Hey ${widget.username.toString().replaceRange(0, 1, widget.username.toString()[0].toUpperCase())}!",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  ListTile(
                    title: Text("Email:"),
                    subtitle: Text(
                      widget.email.toString(),
                      style: GoogleFonts.roboto(color: Colors.white54),
                    ),
                  ),
                  Divider(
                    color:
                        Theme.of(context).colorScheme.secondary.withAlpha(60),
                  ),
                  ListTile(
                    title: Text("Favorites"),
                    trailing: Icon(Iconsax.arrow_right_34),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text("Reset Your Password"),
                    trailing: Icon(Iconsax.arrow_right_34),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: Icon(Iconsax.arrow_right_34),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text(
                              "Logout",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              "Are you sure you want to logout of your account?",
                              style: GoogleFonts.roboto(color: Colors.white60),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style:
                                      GoogleFonts.roboto(color: Colors.white60),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await moview.logout(context);
                                },
                                child: Text(
                                  "Logout",
                                  style: GoogleFonts.roboto(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: Text("About"),
                    trailing: Icon(Iconsax.arrow_right_34),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AboutPage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
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
                                  "© Copyright 2021 Pouria Zeinalzadeh.",
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.search),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("logout"),
                  ),
                  TextButton(
                    onPressed: () {
                      moview.resetPassword(context,
                          emailAddress: widget.email.toString());
                    },
                    child: Text("reset password"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
