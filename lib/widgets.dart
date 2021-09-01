import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

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
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Text(rating),
        ],
      ),
    );
  }
}


