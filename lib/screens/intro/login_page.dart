import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moview/screens/intro/reset_password_page.dart';
import 'package:moview/screens/intro/signup_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String loginUser = '';
  String loginPassword = '';
  bool isHidden = true;
  TapGestureRecognizer recognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    recognizer.onTap = () {
      fadeNavigator(
        context,
        newPage: SignUpPage(),
        duration: 500,
      );
    };
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xFF1E3A53),
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Color(0xff141F32),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Consumer<Moview>(
      builder: (context, value, child) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1E3A53),
                    Color(0xFF193145),
                    Color(0xff141F32),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Hero(
                    tag: 'logo',
                    child: SvgPicture.asset(
                      'assets/images/login.svg',
                      height: MediaQuery.of(context).size.height / 4,
                    ),
                  ),
                  Text(
                    "Welcome back!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.greatVibes(
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    "You've been missed.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: size.height / 15,
                  ),
                  Hero(
                    tag: 'username',
                    child: Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            loginUser = value.trim();
                          });
                        },
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.deepOrangeAccent,
                        cursorRadius: Radius.circular(1),
                        decoration: buildInputDecoration(
                          'Enter your username',
                          'Username',
                          false,
                          Container(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Hero(
                    tag: 'password',
                    child: Material(
                      color: Colors.transparent,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            loginPassword = value;
                          });
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isHidden,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.deepOrangeAccent,
                        cursorRadius: Radius.circular(1),
                        decoration: buildInputDecoration(
                          'Enter your password',
                          'Password',
                          true,
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            icon: Icon(
                              isHidden ? Iconsax.eye_slash : Iconsax.eye,
                              color: isHidden
                                  ? Colors.orangeAccent
                                  : Colors.orange.shade700,
                            ),
                            splashRadius: 22,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordPage(),
                            ),
                          );
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Hero(
                    tag: 'button',
                    child: Align(
                      child: MoviewButton(
                        title: "Login",
                        onPressed: () {
                          moview.login(context, loginUser, loginPassword);
                        },
                        isLoading: moview.loginIsLoading,
                        enableCondition:
                            loginUser.trim().isEmpty || loginPassword.isEmpty,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.white54),
                          ),
                          TextSpan(
                            text: "Sign up.",
                            style: TextStyle(color: Colors.white),
                            recognizer: recognizer,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () async {
                  //     var data = await APIManager().getGenres();
                  //     print(data.genres[1].name);
                  //   },
                  //   child: Text("get genres"),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
