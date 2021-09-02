import 'package:flutter/material.dart';
import 'package:moview/screens/intro/intro_page.dart';
import 'package:moview/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
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
  void logout() async {
    var moview = Provider.of<Moview>(context, listen: false);
    print('logging out...');
    var user = ParseUser(widget.username, widget.password, widget.email);
    var response;
    try {
      response = await user.logout().timeout(Duration(seconds: 10));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('something went wrong. please try again!'),
        ),
      );
      throw error;
    }
    if (response.success) {
      moview.favoriteNumbers = null;
      moview.genreMovieIdList.clear();
      moview.genreMovieNameList.clear();
      moview.genreTvShowIdList.clear();
      moview.genreTvShowNameList.clear();
      moview.movieGenreList.clear();
      moview.movieCountryList.clear();
      moview.movieLanguagesList.clear();
      moview.tvShowGenreList.clear();
      moview.tvShowCreatedByList.clear();
      moview.tvShowCountryList.clear();
      moview.tvShowSeasonNameList.clear();
      moview.tvShowSeasonAirDateList.clear();
      moview.tvShowSeasonPosterList.clear();
      moview.tvShowLanguagesList.clear();
      moview.searchNameList.clear();
      moview.searchPosterList.clear();
      moview.searchIdList.clear();
      moview.searchRateList.clear();
      moview.searchOverviewList.clear();
      moview.searchMediaTypeList.clear();
      moview.searchPosterUrlList.clear();
      moview.genreResultPageList.clear();
      moview.genreResultNameList.clear();
      moview.genreResultIdList.clear();
      moview.genreResultPosterList.clear();
      moview.genreResultPosterUrlList.clear();
      moview.genreResultRateList.clear();
      moview.dbMediaIdList.clear();
      moview.dbMediaNameList.clear();
      moview.dbYearList.clear();
      print('user logged out successfully');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IntroPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hey ${widget.username}!"),
            TextButton(onPressed: logout, child: Text("logout")),
          ],
        ),
      ),
    );
  }
}
