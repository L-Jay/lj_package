import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LJNetworkImage extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  final String url;
  final String? placeholderImageName;
  final Color? placeholderColor;

  final BoxFit fit;

  const LJNetworkImage({
    Key? key,
    this.width,
    this.height,
    required this.url,
    this.placeholderImageName,
    this.placeholderColor,
    this.radius = 0,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, url) {
          return placeholderImageName == null
              ? Container(
            color: placeholderColor ?? Color(0xFFF5F6F6),
          )
              : Image.asset(
            placeholderImageName!,
            fit: fit,
          );
        },
        errorWidget: (context, url, dynamic error) {
          return placeholderImageName == null
              ? Container(
            color: placeholderColor ?? Color(0xFFF5F6F6),
          )
              : Image.asset(
            placeholderImageName!,
            fit: fit,
          );
        },
      ),
    );
  }
}
