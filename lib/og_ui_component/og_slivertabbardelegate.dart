
import 'package:flutter/material.dart';

class OGSliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  OGSliverTabBarDelegate(
    this.tabBar, {
    this.height = 44.0,
    this.color = Colors.white,
  });

  final Widget tabBar;
  final double height;
  final Color color;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      height: height,
      color: color,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(OGSliverTabBarDelegate oldDelegate) {
    return false;
  }
}