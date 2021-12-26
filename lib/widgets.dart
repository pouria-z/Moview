import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moview/screens/details/movie_details_page.dart';
import 'package:moview/screens/details/tvshow_details_page.dart';
import 'package:moview/screens/genre/genre_details_page.dart';
import 'package:moview/services.dart';
import 'package:shimmer/shimmer.dart';

class TimeOutWidget extends StatelessWidget {
  final onRefresh;

  const TimeOutWidget({Key? key, this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Something went wrong. Please try again!"),
          TextButton(
            onPressed: onRefresh,
            child: Icon(
              Icons.refresh,
              color: Colors.grey,
            ),
          ),
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
      width: isLoading ? 70 : MediaQuery.of(context).size.width,
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

class GenreListLoading extends StatelessWidget {
  const GenreListLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: ListView.builder(
        itemCount: 4,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height / 4.5,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(15),
            ),
          );
        },
      ),
      baseColor: Color(0xFF2A3155),
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      direction: ShimmerDirection.ltr,
    );
  }
}

class TrendingLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xFF2A3155),
      highlightColor: Theme.of(context).scaffoldBackgroundColor,
      direction: ShimmerDirection.ltr,
      child: ListView.builder(
        itemCount: 4,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width / 2,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white12,
            ),
          );
        },
      ),
    );
  }
}

ListView moviewGenreList(AsyncSnapshot snapshot,
    {required String type, required List data, required List images}) {
  return ListView.builder(
    shrinkWrap: true,
    physics: BouncingScrollPhysics(),
    itemCount: data.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.primary,
          onTap: () {
            fadeNavigator(
              context,
              duration: 400,
              newPage: GenreDetails(
                type: type,
                id: data[index].id,
                name: data[index].name,
              ),
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: MediaQuery.of(context).size.height / 4.5,
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: CachedNetworkImageProvider(images[index]),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 36,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black54,
                  child: Center(child: Text(data[index].name)),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

fadeNavigator(BuildContext context,
    {required Widget newPage, required int duration}) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: duration),
      reverseTransitionDuration: Duration(milliseconds: duration),
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

Future<dynamic> sharedAxisNavigator(BuildContext context,
    {required Widget newPage, required int duration}) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      transitionDuration: Duration(milliseconds: duration),
      reverseTransitionDuration: Duration(milliseconds: duration),
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
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        shadowColor: Colors.black,
        child: Container(
          height: height,
          width: MediaQuery.of(context).size.width / 2,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: LinearGradient(
              colors: [
                Color(0xFF2A3155),
                Color(0xFF1F2339),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Hero(
                tag: imageUrl,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: CachedNetworkImage(
                    imageUrl: "https://image.tmdb.org/t/p/w500$imageUrl",
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) {
                      return Shimmer.fromColors(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 4.1,
                          width: MediaQuery.of(context).size.width / 3,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        baseColor: Theme.of(context).scaffoldBackgroundColor,
                        highlightColor: Theme.of(context).primaryColor,
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
                          style: GoogleFonts.libreBaskerville(fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 18,
                        ),
                        Text(
                          rating.toString(),
                          style: GoogleFonts.balooBhaijaan(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget moviewGridView(
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
    physics: ScrollPhysics(parent: BouncingScrollPhysics()),
    scrollDirection: scrollDirection,
    controller: scrollController,
    shrinkWrap: true,
    itemCount: data.length,
    itemBuilder: (context, index) {
      final model = data[index];
      return InkWell(
        splashColor: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(7),
        onTap: () {
          if (type == 'tv') {
            animationTransition(
              context,
              TVShowDetails(
                id: model.id,
                title: "${model.title} (${model.releaseDate})",
                posterPath: model.posterPath,
              ),
            );
          } else if (type == 'movie') {
            animationTransition(
              context,
              MovieDetails(
                id: model.id,
                title: "${model.title} (${model.releaseDate})",
                posterPath: model.posterPath,
              ),
            );
          }
        },
        child: MoviewCard(
          height: height,
          id: model.id,
          imageUrl: model.posterPath,
          title: "${model.title} (${model.releaseDate})",
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 5,
        borderRadius: BorderRadius.circular(25),
        shadowColor: Colors.black,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            gradient: LinearGradient(
              colors: [
                Color(0xFF2A3155),
                Color(0xFF1F2339),
                Color(0xFF1F2339),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 25,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: CachedNetworkImage(
                    imageUrl: "https://image.tmdb.org/t/p/w500$imageUrl",
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) {
                      return Shimmer.fromColors(
                        child: Container(
                          height: MediaQuery.of(context).size.height / 7.5,
                          width: MediaQuery.of(context).size.width / 5.5,
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        baseColor: Theme.of(context).scaffoldBackgroundColor,
                        highlightColor: Color(0xFF2A3155),
                      );
                    },
                    errorWidget: (context, url, error) => Icon(Iconsax.danger5),
                    fadeInDuration: Duration(
                      milliseconds: 500,
                    ),
                    height: MediaQuery.of(context).size.height / 7.5,
                    width: MediaQuery.of(context).size.width / 5.5,
                  ),
                ),
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
                      style: GoogleFonts.libreBaskerville(fontSize: 16),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 16,
                        ),
                        Text(
                          " ${rating.toString()}",
                          style: GoogleFonts.balooBhaijaan(fontSize: 16),
                        ),
                      ],
                    ),
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

Widget suggestionCardGridView(context,
    {required List data, required String type}) {
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
            title: "${model.title} (${model.releaseDate})",
            imageUrl: model.posterPath,
            rating: model.voteAverage,
          );
        },
        openBuilder: (context, action) {
          if (type == 'tv') {
            FocusScope.of(context).unfocus();
            return TVShowDetails(
              id: model.id,
              title: "${model.title} (${model.releaseDate})",
              posterPath: model.posterPath,
            );
          } else {
            FocusScope.of(context).unfocus();
            return MovieDetails(
              id: model.id,
              title: "${model.title} (${model.releaseDate})",
              posterPath: model.posterPath,
            );
          }
        },
      );
    },
  );
}

class MoviewRichText extends StatelessWidget {
  const MoviewRichText({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: GoogleFonts.merriweather(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          TextSpan(
            text: description,
            style: GoogleFonts.merriweather(),
          ),
        ],
      ),
    );
  }
}

ScaffoldFeatureController moviewSnackBar(context, {required String response}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        response,
        style: TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      dismissDirection: DismissDirection.horizontal,
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
