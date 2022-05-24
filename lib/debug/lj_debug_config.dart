
import 'package:flutter/material.dart';
import 'package:lj_package/utils/lj_define.dart';
import 'lj_debug_page.dart';

typedef LJDebugServiceChangeCallback = void Function(int debugIndex, Map<
    String,
    String> map);

class LJDebugConfig {
  static List<Map<String, String>> configList;

  static int debugIndex = 0; // 测试版-index
  static bool debugState = false; // 测试版-true   正式版-false

  static LJDebugServiceChangeCallback debugServiceChangeCallback;

  static OverlayEntry entry;

  static void addOverlay(BuildContext context, String title) {
    removeOverlay();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _insertOverlay(context, title));
  }

  static void removeOverlay() {
    entry?.remove();
    entry = null;
  }

  static void _insertOverlay(BuildContext context, String title) {
    entry = OverlayEntry(builder: (context) {
      final size = MediaQuery
          .of(context)
          .size;
      print(size.width);
      return Positioned(
        width: 56,
        height: 56,
        top: size.height - 72,
        left: size.width - 72,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LJDebugPage()));
            },
            child: Container(
              alignment: Alignment.center,
              decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.black38),
              child: quickText(title ?? '', 18, Colors.white),
            ),
          ),
        ),
      );
    });
    return Overlay.of(context).insert(entry);
  }
}
