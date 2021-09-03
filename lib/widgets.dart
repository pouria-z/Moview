import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    return Card(
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
    );
  }
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


