import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var username;
  var email;
  var password;

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Scaffold(
      body: Column(
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
            child: Text("register"),
          ),
        ],
      ),
    );
  }
}
