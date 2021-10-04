import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(String imageUrl){
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) {
      return Container(
        color: Colors.grey,
      );
      // const Center(
      //   child: Icon(
      //     Icons.more_horiz, 
      //     color: Colors.grey,
      //   ),
      // );
    } ,
    errorWidget: (context, url, error) {
      return const Center(
        child: Icon(
          Icons.broken_image, 
          color: Colors.grey,
        ),
      );
    },
    fit: BoxFit.cover,
  );
}