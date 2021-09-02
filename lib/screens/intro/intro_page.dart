import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:moview/screens/home_page.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  var username;
  var email;
  var password;
  var loginUser;
  var loginPassword;

  void register() async {
    print('signing up...');
    var user = ParseUser.createUser(username, password, email);
    var response = await user.signUp();
    if (response.success) {
      print('user created successfully');
    } else {
      print(response.error!.message);
    }
  }

  void login() async {
    print('logging in...');
    var user = ParseUser(loginUser, loginPassword, null);
    var response;
    try {
      response = await user.login().timeout(Duration(seconds: 10));
    } on TimeoutException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('something went wrong. please try again!'),
        ),
      );
      throw e;
    } on SocketException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('something went wrong. please try again!'),
        ),
      );
      throw e;
    }
    if (response.success) {
      print('user logged in successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } else {
      print(response.error!.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${response.error!.message}"),
        ),
      );
    }
  }

  void logout() async {
    print('logging out...');
    var user = ParseUser(loginUser, loginPassword, null);
    var response = await user.logout();
    if (response.success) {
      print('user logged out successfully');
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => Home(),
      //     ));
    } else {
      print(response.error!.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter App"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                username = value;
              },
              decoration: InputDecoration(
                hintText: 'username',
              ),
            ),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration: InputDecoration(
                hintText: 'email',
              ),
            ),
            TextField(
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                hintText: 'password',
              ),
            ),
            TextButton(onPressed: register, child: Text("register")),
            SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) {
                loginUser = value;
              },
              decoration: InputDecoration(
                hintText: 'username',
              ),
            ),
            TextField(
              onChanged: (value) {
                loginPassword = value;
              },
              decoration: InputDecoration(
                hintText: 'password',
              ),
            ),
            TextButton(onPressed: login, child: Text("login")),
            // TextButton(onPressed: logout, child: Text("logout")),
          ],
        ),
      ),
    );
  }
}
