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
                    leading: Icon(
                      Iconsax.message,
                      color: Colors.white38,
                    ),
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
                    leading: Icon(
                      Iconsax.heart,
                      color: Colors.white38,
                    ),
                    title: Text("Favorites"),
                    trailing: Icon(Iconsax.arrow_right_34),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(
                      Iconsax.key,
                      color: Colors.white38,
                    ),
                    title: Text("Reset Your Password"),
                    trailing: Icon(Iconsax.arrow_right_34),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: Text(
                              "Reset Password",
                              style: TextStyle(color: Colors.white),
                            ),
                            content: Text(
                              "We will send you a reset password link to your "
                              "email address.\nAre you sure you want to do this?",
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
                                  await moview.resetPassword(
                                    context,
                                    emailAddress: widget.email.toString(),
                                  );
                                },
                                child: Text(
                                  "Send Reset Link",
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
                    leading: Icon(
                      Iconsax.info_circle,
                      color: Colors.white38,
                    ),
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
                  ListTile(
                    leading: Icon(
                      Iconsax.logout_1,
                      color: Colors.red.withAlpha(120),
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    trailing: Icon(
                      Iconsax.arrow_right_34,
                      color: Colors.red,
                    ),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
