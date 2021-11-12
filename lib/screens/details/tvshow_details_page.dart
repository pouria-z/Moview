import 'package:flutter/material.dart';
import 'package:moview/widgets.dart';
import 'package:moview/services.dart';
import 'package:provider/provider.dart';
import 'package:marquee/marquee.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class TVShowDetails extends StatefulWidget {
  final id;
  final tvShowName;
  final tvShowPosterUrl;

  const TVShowDetails(
      {Key? key, @required this.id, this.tvShowName, this.tvShowPosterUrl})
      : super(key: key);

  @override
  _TVShowDetailsState createState() => _TVShowDetailsState();
}

class _TVShowDetailsState extends State<TVShowDetails> {
  var failed =
      "https://forums.codemasters.com/uploads/monthly_2020_03/image.png.f8c83b98a2250b117a112bcfb92ca287.png";
  var isFavorite;

  @override
  void initState() {
    super.initState();
    print("tv show id: ${widget.id}");
    var moview = Provider.of<Moview>(context, listen: false);
    moview.timeOutException = false;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await moview.setAndGetId(widget.id, 'tv');
      isFavorite = moview.isFave;
      await moview.getTvShowDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var moview = Provider.of<Moview>(context, listen: false);
    return Consumer<Moview>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: widget.tvShowName.toString().characters.length < 30
              ? AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  title: Text(
                    widget.tvShowName == null ? "" : widget.tvShowName,
                    style: TextStyle(fontSize: 25),
                  ),
                )
              : AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  flexibleSpace: SafeArea(
                    child: widget.tvShowName == null
                        ? Container()
                        : Marquee(
                            text: widget.tvShowName,
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
          body: moview.timeOutException == true
              ? TimeOutWidget(
                  function: () {
                    setState(() {
                      moview.getTvShowDetails(widget.id);
                    });
                  },
                )
              : Column(
                  children: [
                    moview.getTvShowDetailsIsLoading == true
                        ? Shimmer.fromColors(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 3.5,
                              alignment: Alignment.topCenter,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            baseColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            highlightColor: Colors.grey,
                          )
                        : CachedNetworkImage(
                            imageUrl: moview.tvShowCoverUrl,
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
                        Hero(
                          tag: widget.tvShowPosterUrl,
                          child: CachedNetworkImage(
                            imageUrl: widget.tvShowPosterUrl,
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 3,
                            alignment: Alignment.center,
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Hero(
                                tag: widget.id,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    widget.tvShowName,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              moview.getTvShowDetailsIsLoading == true
                                  ? Shimmer.fromColors(
                                      baseColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      highlightColor: Colors.grey,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.favorite_border_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          isFavorite == null
                                              ? isFavorite = true
                                              : isFavorite = null;
                                        });
                                        await moview
                                            .setAndGetId(widget.id, 'tv')
                                            .timeout(Duration(seconds: 5),
                                                onTimeout: () {
                                          setState(() {
                                            isFavorite == null
                                                ? isFavorite = true
                                                : isFavorite = null;
                                            moview.isFave = isFavorite;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('something went wrong!'),
                                            ),
                                          );
                                        });
                                        if (moview.isFave == null) {
                                          setState(() {
                                            moview.isFave = isFavorite;
                                          });
                                          await moview.setFavorite(
                                              widget.id, 'tv');
                                        } else if (moview.isFave == true) {
                                          setState(() {
                                            moview.isFave = isFavorite;
                                          });
                                          await moview.unsetFavorite();
                                        }
                                      },
                                      icon: isFavorite == true
                                          ? Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_border_rounded,
                                            ),
                                    ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(moview.tvShowTagLine.toString()),
                    Text(moview.tvShowLanguagesList.toString()),
                    Text(moview.tvShowGenreList.toString()),
                  ],
                ),
        );
      },
    );
  }
}
