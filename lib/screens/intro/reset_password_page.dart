import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SvgPicture.asset(
                    'assets/images/forgot-password.svg',
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                  Text(
                    "Forgot your password? Don't worry! We will help you get a new password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54),
                  ),
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
                  Align(
                    child: MoviewButton(
                      title: "Send Email",
                      onPressed: () {
                        moview.resetPassword(context, emailAddress: resetEmail);
                      },
                      isLoading: moview.resetPasswordIsLoading,
                      enableCondition: resetEmail.trim().isEmpty,
                    ),
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
