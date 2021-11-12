import 'package:flutter/material.dart';
import 'package:moview/key.dart';
import 'package:moview/screens/intro/intro_page.dart';
import 'package:moview/screens/home_page.dart';
import 'package:moview/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  final keyParseServerUrl = 'https://parseapi.back4app.com';
  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  ParseResponse? parseResponse;
  Future isUserLoggedIn() async {
    ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
    if (currentUser == null) {
      return false;
    }
    //Checks whether the user's session token is valid
    parseResponse =
        await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);
  }
  await isUserLoggedIn();

  runApp(
    ChangeNotifierProvider(
      create: (context) => Moview(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: parseResponse?.success == null || !parseResponse!.success
            ? IntroPage()
            : HomePage(),
      ),
    ),
  );
}
