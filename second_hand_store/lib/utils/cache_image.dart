import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cacheNetWorkImage(String url,
    {double? width, double? height, BoxFit? fit}) {
  return CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        color: Colors.orange[300],
      ),
    ),
    errorWidget: (context, url, error) => const Icon(Icons.error),
    width: width,
    height: height,
    fit: fit,
  );
}
