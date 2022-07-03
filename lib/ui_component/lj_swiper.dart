import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';

class LJSwiper<T> extends StatefulWidget {
  final List<T> viewModels;
  final SwiperOnTap? onTap;
  final Alignment? paginationAlignment;
  final EdgeInsets? paginationPadding;
  final EdgeInsets padding;
  final double connerRadius;
  final double aspectRatio;
  final Color? backgroundColor;
  final BoxShadow? shadow;
  final int imageType;
  final BoxFit? fit;
  final String Function(T t) getImgUrl;

  LJSwiper(
      {Key? key,
      required this.viewModels,
      required this.getImgUrl,
      this.onTap,
      this.padding = const EdgeInsets.all(0),
      this.connerRadius = 0,
      this.aspectRatio = 16 / 9,
      this.backgroundColor,
      this.fit,
      this.imageType = 0,
      this.paginationAlignment,
      this.paginationPadding,
      this.shadow})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LJSwiperState<T>();
}

class _LJSwiperState<T> extends State<LJSwiper<T>> {
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
                    widget.shadow!,
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
                return widget.imageType == 1
                    ? Image.asset(
                        widget.getImgUrl(widget.viewModels[index]),
                        fit: widget.fit,
                      )
                    : CachedNetworkImage(
                        imageUrl: widget.getImgUrl(widget.viewModels[index]),
                        fit: widget.fit,
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
          alignment: widget.paginationAlignment ?? Alignment(1, 1),
          child: Padding(
            padding: widget.paginationPadding ??
                const EdgeInsets.only(right: 18, bottom: 14),
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
