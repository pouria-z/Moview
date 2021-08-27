import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';

class TVShowDetails extends StatefulWidget {
  final id;

  const TVShowDetails({Key? key, @required this.id}) : super(key: key);

  @override
  _TVShowDetailsState createState() => _TVShowDetailsState();
}

class _TVShowDetailsState extends State<TVShowDetails> {
  var failed =
      "https://forums.codemasters.com/uploads/monthly_2020_03/image.png.f8c83b98a2250b117a112bcfb92ca287.png";
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    print("tv show id: ${widget.id}");
    var moview = Provider.of<Moview>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      moview.favoriteType = 'tv';
      moview.favoriteMediaId = widget.id;
      moview.tvShowId = widget.id;
      moview.setAndGetId();
      moview.getTvShowDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: moview.tvShowName.toString().characters.length < 30
              ? AppBar(
                  title: Text(
                    moview.tvShowName == null ? "" : moview.tvShowName,
                    style: TextStyle(fontSize: 25),
                  ),
                )
              : AppBar(
                  flexibleSpace: SafeArea(
                    child: moview.tvShowName == null
                        ? Container()
                        : Marquee(
                            text: moview.tvShowName,
                            style: TextStyle(fontSize: 25, color: Colors.white),
                            scrollAxis: Axis.horizontal,
                            blankSpace: MediaQuery.of(context).size.width / 2,
                            velocity: 100.0,
                            pauseAfterRound: Duration(seconds: 1),
                            showFadingOnlyWhenScrolling: false,
                            fadingEdgeStartFraction: 0.3,
                            fadingEdgeEndFraction: 0.5,
                            numberOfRounds: 5,
                            startPadding: 50.0,
                            decelerationCurve: Curves.linearToEaseOut,
                            textDirection: TextDirection.ltr,
                          ),
                  ),
                ),
          body: moview.tvShowName == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Image.network(
                      moview.tvShowCover == null
                          ? failed
                          : moview.tvShowCoverUrl,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3.5,
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          moview.tvShowPosterUrl,
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          alignment: Alignment.center,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                moview.tvShowName,
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    await moview.setAndGetId();
                                    if (moview.theId == null) {
                                      setState(() {
                                        isFavorite = !isFavorite;
                                        moview.theId = moview.favoriteId;
                                      });
                                      moview.isFave = isFavorite;
                                      await moview.setFavorite();
                                    } else if (moview.theId ==
                                        moview.favoriteId) {
                                      setState(() {
                                        isFavorite = !isFavorite;
                                      });
                                      moview.isFave = isFavorite;
                                      await moview.unsetFavorite().whenComplete(
                                          () => moview.favoriteId = null);
                                    }
                                  },
                                  icon: moview.theId == moview.favoriteId
                                      ? Icon(
                                          Icons.favorite_rounded,
                                          color: Colors.red,
                                        )
                                      : Icon(
                                          Icons.favorite_border_rounded,
                                        )),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(moview.tvShowTagLine),
                    Text(moview.tvShowLanguagesList.toString()),
                    Text(moview.tvShowGenreList.toString()),
                  ],
                ),
        );
      },
    );
  }
}
