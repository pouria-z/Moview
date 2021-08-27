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
    var moview = Provider.of<Moview>(context,listen: false);
    print('logging out...');
    var user = ParseUser(widget.username, widget.password, widget.email);
    var response = await user.logout();
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
      moview.genreResultTvNameList.clear();
      moview.genreResultMovieNameList.clear();
      moview.genreResultIdList.clear();
      moview.genreResultPosterList.clear();
      moview.genreResultPosterUrlList.clear();
      moview.genreResultRateList.clear();
      moview.dbMovieIdList.clear();
      moview.favoritePageIdList.clear();
      moview.favoritePageNameList.clear();
      moview.favoritePageYearList.clear();
      moview.favoritePagePosterUrlList.clear();
      print('user logged out successfully');
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IntroPage(),
          ));
    } else {
      print(response.error!.message);
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
