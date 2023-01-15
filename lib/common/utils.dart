import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Utils{


static Widget loadingCircle(bool isLoading) {
    return isLoading
        ? Positioned(
            child: Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              color: Colors.white.withOpacity(0.7),
            ),
          )
        : Container();
  }



  static Widget cacheNetworkImageWithEvent(
      context, String imageURL, double width, double height) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: CachedNetworkImage(
          imageUrl: imageURL,
          placeholder: (context, url) => Container(
            transform: Matrix4.translationValues(0.0, 0.0, 0.0),
            child: Container(
                width: width,
                height: height,
                child: Center(child: new CircularProgressIndicator())),
          ),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          width: 500,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

 static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890".codeUnitAt(Random().nextInt('AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890'
.length))));


}
