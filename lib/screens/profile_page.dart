import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:moview/widgets.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final email;
  final password;
  final username;

  const ProfilePage(
      {Key? key,
      @required this.email,
      @required this.password,
      @required this.username})
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
    return Scaffold(
      appBar: buildAppBar(context, "Profile"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hey ${widget.username}!"),
            TextButton(
                onPressed: () {
                  return moview.logout(context);
                },
                child: Text("logout")),
            TextButton(
                onPressed: () {
                  return moview.resetPassword(context);
                },
                child: Text("reset password")),
          ],
        ),
      ),
    );
  }
}
