
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OGNetworkImage extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  final String url;

  final BoxFit fit;

  const OGNetworkImage({
    Key key,
    this.width,
    this.height,
    this.url,
    this.radius = 0,
    this.fit = BoxFit.fill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url ?? "",
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) {
          return Container(
            color: Color(0xFFF5F6F6),
          );
        },
      ),
    );
  }
}