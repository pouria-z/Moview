import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moview/screens/intro/login_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isHidden = true;
  String username = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool passwordIsValid = false;
  TapGestureRecognizer recognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    recognizer.onTap = () {
      fadeNavigator(
        context,
        newPage: LoginPage(),
        duration: 500,
      );
    };
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Color(0xff1e1e34),
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Color(0xff120f31),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    var size = MediaQuery.of(context).size;
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff120f31),
                  Color(0xff272350),
                  Color(0xff1e1e34),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: size.width,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            "Welcome to Moview",
                            style: GoogleFonts.greatVibes(
                              fontSize: 48,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "\nA place where you can find your favorite movies and TV-Shows.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                      Hero(
                        tag: 'logo',
                        child: SvgPicture.asset(
                          'assets/images/signup.svg',
                          height: MediaQuery.of(context).size.height / 4.2,
                        ),
                      ),
                      Hero(
                        tag: 'username',
                        child: Material(
                          color: Colors.transparent,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                username = value;
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
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.deepOrangeAccent,
                        cursorRadius: Radius.circular(1),
                        decoration: buildInputDecoration(
                          'Enter your email',
                          'Email',
                          false,
                          Container(),
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
                                password = value;
                              });
                            },
                            validator: (value) {
                              if (value!.length < 8) {
                                Future.delayed(Duration.zero).then((_) {
                                  setState(() {
                                    passwordIsValid = false;
                                  });
                                });
                                return "Password should be at least 8 characters!";
                              } else {
                                Future.delayed(Duration.zero).then((_) {
                                  setState(() {
                                    passwordIsValid = true;
                                  });
                                });
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            cursorColor: Colors.deepOrangeAccent,
                            cursorRadius: Radius.circular(1),
                            obscureText: isHidden,
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
                        height: 20,
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            confirmPassword = value;
                          });
                        },
                        validator: (value) {
                          if (value != password) {
                            return "Passwords don't match";
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.done,
                        cursorColor: Colors.deepOrangeAccent,
                        cursorRadius: Radius.circular(1),
                        obscureText: isHidden,
                        decoration: buildInputDecoration(
                          'Enter your password again',
                          'Confirm Password',
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
                      SizedBox(
                        height: 20,
                      ),
                      Hero(
                        tag: 'button',
                        child: MoviewButton(
                          title: "Create Account",
                          onPressed: () {
                            moview.signup(
                              context,
                              username: username,
                              password: password,
                              email: email,
                            );
                          },
                          isLoading: moview.registerIsLoading,
                          enableCondition: username.trim().isEmpty ||
                              email.trim().isEmpty ||
                              password.trim().isEmpty ||
                              confirmPassword.trim().isEmpty ||
                              !passwordIsValid ||
                              (password != confirmPassword),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have account? ",
                              style: TextStyle(color: Colors.white54),
                            ),
                            TextSpan(
                              text: "Login.",
                              style: TextStyle(color: Colors.white),
                              recognizer: recognizer,
                            ),
                          ],
                        ),
                      ),
                    ],
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
