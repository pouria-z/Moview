import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:moview/services.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animations/animations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeOutWidget extends StatelessWidget {
  final onRefresh;

  const TimeOutWidget({Key? key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("something went wrong. please try again!"),
          TextButton(
              onPressed: onRefresh,
              child: Icon(
                Icons.refresh,
                color: Colors.grey,
              )),
        ],
      ),
    );
  }
}

InputDecoration buildInputDecoration(
    String hintText, String labelText, bool isPassword, Widget suffixIcon) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText,
    labelStyle: TextStyle(
      color: Colors.orangeAccent.withAlpha(150),
    ),
    suffixIcon: isPassword ? suffixIcon : Padding(padding: EdgeInsets.zero),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red)),
    focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.red)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.orange.shade700)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.orangeAccent)),
  );
}

class MoviewButton extends StatelessWidget {
  const MoviewButton({
    required this.title,
    required this.onPressed,
    required this.isLoading,
    required this.enableCondition,
  });

  final String title;
  final onPressed;
  final bool isLoading;
  final enableCondition;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isLoading ? 50 : MediaQuery.of(context).size.width,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isLoading ? 50 : 15),
        gradient: LinearGradient(
          colors: [
            Color(0xFFDF8547),
            Color(0xFFF15A29),
          ],
        ),
      ),
      duration: Duration(milliseconds: 200),
      child: MaterialButton(
        onPressed: isLoading || enableCondition ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: Colors.white,
                ),
              )
            : Text(title),
        splashColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

Future<dynamic> animationNavigator(BuildContext context, newPage) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 600),
      reverseTransitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return newPage;
      },
    ),
  );
}

class MoviewCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double? rating;
  final int id;
  final double? height;

  const MoviewCard({
    required this.height,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width / 2,
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          elevation: 5,
          shadowColor: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: imageUrl,
                child: CachedNetworkImage(
                  imageUrl: "https://image.tmdb.org/t/p/w500$imageUrl",
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
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: id,
                      child: Material(
                        color: Colors.transparent,
                        child: AutoSizeText(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Text(rating.toString()),
                  ],
                ),
              )
            ],
          ),
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
        return InkWell(
          splashColor: Color(0xFF36367C),
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            moview.tvShowName = null;
            moview.movieName = null;
            moview.getTvShowDetailsIsLoading = true;
            moview.getMovieDetailsIsLoading = true;
            if (type.runtimeType == String
                ? type == 'tv'
                : type[index] == 'tv') {
              animationTransition(
                context,
                TVShowDetails(
                  id: id[index],
                  tvShowName: name[index],
                  tvShowPosterUrl: poster[index],
                ),
              );
            } else if (type.runtimeType == String
                ? type == 'movie'
                : type[index] == 'movie') {
              animationTransition(
                context,
                MovieDetails(
                  id: id[index],
                  movieName: name[index],
                  moviePosterUrl: poster[index],
                ),
              );
            }
          },
          child: MoviewCard(
            height: MediaQuery.of(context).size.height / 3,
            id: id[index],
            imageUrl: poster[index],
            title: name[index],
            rating: rate[index].runtimeType == String
                ? rate[index]
                : rate[index].toDouble().toString(),
          ),
        );
      },
    ),
  );
}

Widget moviewGridView2(
  BuildContext context,
  Moview moview, {
  required double? height,
  required double? mainAxisExtent,
  required int itemsInRow,
  required Axis scrollDirection,
  required ScrollController scrollController,
  required List data,
  required String type,
}) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: itemsInRow,
      mainAxisSpacing: 2,
      crossAxisSpacing: 10,
      mainAxisExtent: mainAxisExtent,
    ),
    physics: BouncingScrollPhysics(),
    scrollDirection: scrollDirection,
    controller: scrollController,
    shrinkWrap: true,
    itemCount: data.length,
    itemBuilder: (context, index) {
      final model = data[index];
      return InkWell(
        splashColor: Color(0xFF36367C),
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          moview.tvShowName = null;
          moview.movieName = null;
          moview.getTvShowDetailsIsLoading = true;
          moview.getMovieDetailsIsLoading = true;
          if (type.runtimeType == String ? type == 'tv' : type[index] == 'tv') {
            animationTransition(
              context,
              TVShowDetails(
                id: model.id,
                tvShowName: model.title,
                tvShowPosterUrl: model.posterPath,
              ),
            );
          } else if (type.runtimeType == String
              ? type == 'movie'
              : type[index] == 'movie') {
            animationTransition(
              context,
              MovieDetails(
                id: model.id,
                movieName: model.title,
                moviePosterUrl: model.posterPath,
              ),
            );
          }
        },
        child: MoviewCard(
          height: height,
          id: model.id,
          imageUrl: model.posterPath,
          title: model.title,
          rating: model.voteAverage,
        ),
      );
    },
  );
}

Future<dynamic> animationTransition(BuildContext context, newPage) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      reverseTransitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return newPage;
      },
    ),
  );
}

class MoviewSuggestionCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double? rating;

  const MoviewSuggestionCard(
      {required this.imageUrl, required this.title, required this.rating});

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
            imageUrl: "https://image.tmdb.org/t/p/w500$imageUrl",
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
                Text(rating.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// for search page
Widget suggestionCardGridView(context, {required List data, required String type}) {
  var moview = Provider.of<Moview>(context, listen: false);
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 1,
      mainAxisExtent: MediaQuery.of(context).size.height / 6.5,
    ),
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    shrinkWrap: true,
    physics: PageScrollPhysics(),
    itemCount: data.length,
    itemBuilder: (context, index) {
      final model = data[index];
      return OpenContainer(
        closedElevation: 0,
        middleColor: Theme.of(context).scaffoldBackgroundColor,
        closedColor: Theme.of(context).scaffoldBackgroundColor,
        openColor: Theme.of(context).scaffoldBackgroundColor,
        transitionDuration: Duration(milliseconds: 400),
        transitionType: ContainerTransitionType.fade,
        closedBuilder: (context, action) {
          return MoviewSuggestionCard(
            title: model.title,
            imageUrl: model.posterPath,
            rating: model.voteAverage,
          );
        },
        openBuilder: (context, action) {
          moview.tvShowName = null;
          moview.movieName = null;
          moview.getTvShowDetailsIsLoading = true;
          moview.getMovieDetailsIsLoading = true;
          if (type == 'tv') {
            FocusScope.of(context).unfocus();
            return TVShowDetails(
              id: model.id,
              tvShowName: model.title,
              tvShowPosterUrl: model.posterPath,
            );
          } else {
            FocusScope.of(context).unfocus();
            return MovieDetails(
              id: model.id,
              movieName: model.title,
              moviePosterUrl: model.posterPath,
            );
          }
        },
      );
    },
  );
}

ScaffoldFeatureController message(context, response) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(response.toString()),
    ),
  );
}

AppBar buildAppBar(BuildContext context,
    {required String title, required Widget action}) {
  return AppBar(
    backgroundColor: Theme.of(context).primaryColor,
    leading: Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: [
              Flexible(
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  alignment: Alignment.centerRight,
                ),
              ),
              SizedBox(
                height: 3,
              ),
            ],
          ),
        ),
      ],
    ),
    leadingWidth: MediaQuery.of(context).size.width / 3,
    title: Text(title),
    centerTitle: true,
    elevation: 0,
    actions: [
      action,
    ],
  );
}
