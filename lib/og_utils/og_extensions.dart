
import 'package:flutter/widgets.dart';

extension StringExtensions on String {
  int toInt() {
    return int.parse(this);
  }

  double toDouble() {
    return double.parse(this);
  }

  bool verifyPhone() {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    bool matched = exp.hasMatch(this);

    return matched;
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