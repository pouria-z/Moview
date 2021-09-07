import 'package:flutter/material.dart';
import 'package:moview/services.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animations/animations.dart';

class TimeOutWidget extends StatelessWidget {
  final function;

  const TimeOutWidget({Key? key, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("something went wrong. please try again!"),
          TextButton(
              onPressed: function,
              child: Icon(
                Icons.refresh,
                color: Colors.grey,
              )),
        ],
      ),
    );
  }
}

class MoviewCard extends StatelessWidget {
  final imageUrl;
  final title;
  final rating;

  const MoviewCard({Key? key, this.imageUrl, this.title, this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.red,
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 5,
        shadowColor: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              progressIndicatorBuilder: (context, url, progress) {
                return Shimmer.fromColors(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4.1,
                    width: MediaQuery.of(context).size.width / 3,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  baseColor: Theme.of(context).scaffoldBackgroundColor,
                  highlightColor: Color(0xFF383838),
                );
              },
              errorWidget: (context, url, error) => Icon(Iconsax.danger5),
              fadeInDuration: Duration(
                milliseconds: 500,
              ),
              height: MediaQuery.of(context).size.height / 4.1,
              width: MediaQuery.of(context).size.width / 3,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(rating),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget moviewGridView(
    context, scrollController, type, id, poster, name, rate, length) {
  var moview = Provider.of<Moview>(context, listen: false);
  return Expanded(
    child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 2,
        mainAxisExtent: MediaQuery.of(context).size.height / 3,
      ),
      physics: BouncingScrollPhysics(),
      controller: scrollController,
      shrinkWrap: true,
      itemCount: length,
      itemBuilder: (context, index) {
        return OpenContainer(
          closedElevation: 0,
          middleColor: Theme.of(context).scaffoldBackgroundColor,
          closedColor: Theme.of(context).scaffoldBackgroundColor,
          openColor: Theme.of(context).scaffoldBackgroundColor,
          transitionDuration: Duration(milliseconds: 300),
          transitionType: ContainerTransitionType.fade,
          closedBuilder: (context, action) {
            return MoviewCard(
              imageUrl: poster[index],
              title: name[index],
              rating: rate[index].runtimeType == String
                  ? rate[index]
                  : rate[index].toDouble().toString(),
            );
          },
          openBuilder: (context, action) {
            moview.tvShowName = null;
            moview.movieName = null;
            moview.getTvShowDetailsIsLoading = true;
            moview.getMovieDetailsIsLoading = true;
            if (type.runtimeType == String
                ? type == 'tv'
                : type[index] == 'tv') {
              return TVShowDetails(
                id: id[index],
              );
            } else if (type.runtimeType == String
                ? type == 'movie'
                : type[index] == 'movie') {
              return MovieDetails(id: id[index]);
            }
            return Container();
          },
        );
      },
    ),
  );
}

class MoviewSuggestionCard extends StatelessWidget {
  final imageUrl;
  final title;
  final rating;

  const MoviewSuggestionCard({Key? key, this.imageUrl, this.title, this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 5,
      shadowColor: Colors.black,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 25,
          ),
          CachedNetworkImage(
            imageUrl: imageUrl,
            progressIndicatorBuilder: (context, url, progress) {
              return Shimmer.fromColors(
                child: Container(
                  height: MediaQuery.of(context).size.height / 7.5,
                  width: MediaQuery.of(context).size.width / 5.5,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                baseColor: Theme.of(context).scaffoldBackgroundColor,
                highlightColor: Color(0xFF383838),
              );
            },
            errorWidget: (context, url, error) => Icon(Iconsax.danger5),
            fadeInDuration: Duration(
              milliseconds: 500,
            ),
            height: MediaQuery.of(context).size.height / 7.5,
            width: MediaQuery.of(context).size.width / 5.5,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 15,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(rating),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget suggestionCardGridView(context) {
  var moview = Provider.of<Moview>(context, listen: false);
  return moview.searchTypeNameList.isNotEmpty
      ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisExtent: MediaQuery.of(context).size.height / 6.5,
          ),
          shrinkWrap: true,
          itemCount: moview.searchTypeNameList.length > 5
              ? 5
              : moview.searchTypeNameList.length,
          itemBuilder: (context, index) {
            return OpenContainer(
              closedElevation: 0,
              middleColor: Theme.of(context).scaffoldBackgroundColor,
              closedColor: Theme.of(context).scaffoldBackgroundColor,
              openColor: Theme.of(context).scaffoldBackgroundColor,
              transitionDuration: Duration(milliseconds: 300),
              transitionType: ContainerTransitionType.fade,
              closedBuilder: (context, action) {
                return MoviewSuggestionCard(
                  title: moview.searchTypeNameList[index],
                  imageUrl: moview.searchTypePosterUrlList[index],
                  rating: moview.searchTypeRateList[index].toString(),
                );
              },
              openBuilder: (context, action) {
                moview.tvShowName = null;
                moview.movieName = null;
                moview.getTvShowDetailsIsLoading = true;
                moview.getMovieDetailsIsLoading = true;
                if (moview.searchTypeMediaTypeList[index] == 'tv') {
                  FocusScope.of(context).unfocus();
                  return TVShowDetails(id: moview.searchTypeIdList[index]);
                } else {
                  FocusScope.of(context).unfocus();
                  return MovieDetails(id: moview.searchTypeIdList[index]);
                }
              },
            );
          },
        )
      : Text("Oops! Found Nothing :(");
}

ScaffoldFeatureController message(context, response) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(response.toString()),
    ),
  );
}
