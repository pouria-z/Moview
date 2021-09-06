import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
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
            TextButton(
                onPressed: () {
                  return moview.register(context, username, password, email);
                },
                child: Text("register")),
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
            TextButton(
                onPressed: () {
                  return moview.login(context, loginUser, loginPassword);
                },
                child: Text("login")),
            // TextButton(onPressed: logout, child: Text("logout")),
          ],
        ),
      ),
    );
  }
}
