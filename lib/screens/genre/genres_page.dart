import 'package:flutter/material.dart';
import 'package:moview/screens/intro/intro_page.dart';
import 'package:moview/screens/genre/genre_details_page.dart';
import 'package:moview/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

class GenresPage extends StatefulWidget {
  final username;
  final email;
  final password;

  const GenresPage({this.username, this.email, this.password});

  @override
  _GenresPageState createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  void logout() async {
    print('logging out...');
    var user = ParseUser(widget.username, widget.password, null);
    var response = await user.logout();
    if (response.success) {
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
  void initState() {
    super.initState();
    var moview = Provider.of<Moview>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      if(moview.genreMovieNameList.isEmpty){
        await moview.getMovieGenreList();
      }else{
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          body: moview.genreMovieNameList.isEmpty ||
                  moview.genreMovieIdList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: moview.genreMovieIdList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(moview.genreMovieNameList[index]),
                      leading: Icon(Icons.star_rounded),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenreDetails(
                                type: 'movie',
                                id: moview.genreMovieIdList[index],
                                pageNumber: 1,
                              ),
                            ));
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
