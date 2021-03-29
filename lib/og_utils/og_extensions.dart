
import 'package:flutter/widgets.dart';

extension StringExtensions on String {
  int toInt() {
    return int.parse(this);
  }

  double toDouble() {
    return double.parse(this);
  }
}

extension StateExtension on State {
  EdgeInsets get padding {
    return MediaQuery.of(context).padding;
  }

  double get top {
    return MediaQuery.of(context).padding.top;
  }

  double get bottom {
    return MediaQuery.of(context).padding.bottom;
  }

  double get left {
    return MediaQuery.of(context).padding.left;
  }

  double get right {
    return MediaQuery.of(context).padding.right;
  }

  double get width {
    return MediaQuery.of(context).size.width;
  }

  double get height {
    return MediaQuery.of(context).size.height;
  }
}