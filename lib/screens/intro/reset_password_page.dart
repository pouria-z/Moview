import 'package:flutter/material.dart';
import 'package:moview/screens/intro/login_page.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String resetEmail = '';

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var moview = Provider.of<Moview>(
      context,
      listen: false,
    );
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Reset Your Password"),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        resetEmail = value.trim();
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
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
                  MoviewButton(
                    title: "Send Email",
                    onPressed: () {
                      moview.resetPassword(context);
                    },
                    isLoading: moview.resetPasswordIsLoading,
                    enableCondition: resetEmail.trim().isEmpty,
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
