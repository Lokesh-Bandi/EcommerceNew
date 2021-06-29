import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
class HeroAnimation1 extends StatelessWidget {
  @override
  var url;
  var index;
  HeroAnimation1({this.url,this.index});

  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: PhotoView(
            imageProvider: NetworkImage(url),
            // heroAttributes: PhotoViewHeroAttributes(tag: url+index.toString()),
          ),
        ),
      ),
    );
  }
}
