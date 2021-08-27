import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:provider/provider.dart';

class GenreDetails extends StatefulWidget {
  final type;
  final id;
  final pageNumber;

  const GenreDetails(
      {Key? key,
      @required this.type,
      @required this.id,
      @required this.pageNumber})
      : super(key: key);

  @override
  _GenreDetailsState createState() => _GenreDetailsState();
}

class _GenreDetailsState extends State<GenreDetails> {
  @override
  void initState() {
    super.initState();
    print("genre id: ${widget.id}");
    var moview = Provider.of<Moview>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      moview.type = widget.type;
      moview.genreMovieId = widget.id;
      moview.genreResultPage = widget.pageNumber;
      await moview.getGenreResultList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Scaffold(body: SafeArea(
      child: Consumer<Moview>(
        builder: (context, value, child) {
          return moview.genreResultMovieNameList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Text("Page ${moview.genreResultPage}"),
                    Expanded(
                      flex: 15,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(moview.genreResultMovieNameList[index]),
                            leading: Icon(Icons.ac_unit_rounded),
                            onTap: () {
                              moview.movieGenreList.clear();
                              moview.movieLanguagesList.clear();
                              moview.movieCountryList.clear();
                              if (moview.movieName != null) {
                                moview.movieName = null;
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MovieDetails(
                                      id: moview.genreResultIdList[index],
                                    ),
                                  ));
                            },
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: moview.genreResultTotalPages,
                        itemBuilder: (context, index) {
                          var i = index + 1;
                          return TextButton(
                              onPressed: () {
                                moview.genreResultPage = i;
                                moview.genreResultTvNameList.clear();
                                moview.genreResultMovieNameList.clear();
                                moview.genreResultPosterList.clear();
                                moview.genreResultRateList.clear();
                                moview.getGenreResultList();
                              },
                              child: Text(i.toString()));
                        },
                      ),
                    )
                  ],
                );
        },
      ),
    ));
  }
}
