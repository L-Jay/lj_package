import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class OGSwiper<T> extends StatefulWidget {
  final List<T> viewModels;
  final SwiperOnTap onTap;
  final EdgeInsets padding;
  final double connerRadius;
  final double aspectRatio;
  final Color backgroundColor;
  final Shadow shadow;
  final String Function(T t) getImgUrl;

  OGSwiper({
    Key key,
    @required List<T> viewModels,
    @required this.getImgUrl,
    this.onTap,
    this.padding = const EdgeInsets.all(0),
    this.connerRadius = 0,
    this.aspectRatio = 16 / 9,
    this.backgroundColor,
    this.shadow
  })  : this.viewModels = viewModels ?? [],
        super(key: key);

  @override
  State<StatefulWidget> createState() => _OGSwiperState<T>();
}

class _OGSwiperState<T> extends State<OGSwiper<T>> {
  List<T> get list => widget.viewModels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.connerRadius),
            boxShadow: widget.shadow != null
                ? [
                    widget.shadow,
                  ]
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.connerRadius),
            child: Swiper(
              autoplay: widget.viewModels.length > 1,
              loop: widget.viewModels.length > 1,
              itemCount: widget.viewModels.length,
              itemBuilder: (BuildContext context, int index) {
                return CachedNetworkImage(
                  imageUrl: widget.getImgUrl(widget.viewModels[index]),
                );
              },
              onTap: (index) {
                widget.onTap?.call(index);
              },
              pagination: widget.viewModels.length > 1
                  ? _buildSwiperCustomPagination()
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  SwiperPlugin _buildSwiperCustomPagination() {
    return SwiperCustomPagination(
      builder: (BuildContext context, SwiperPluginConfig config) {
        return Align(
          alignment: Alignment(1, 1),
          child: Padding(
            padding: const EdgeInsets.only(right: 18, bottom: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                config.itemCount,
                (index) {
                  return Container(
                    width: config.activeIndex == index ? 14 : 5,
                    height: 5,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
  
  
}
