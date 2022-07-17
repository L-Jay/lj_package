import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lj_package/utils/lj_define.dart';
import '../utils/lj_util.dart';
import 'lj_debug_page.dart';

typedef LJServiceChangeCallback = void Function(Map<String, String> map);

class LJDebugConfig {
  /*务必第一个配置正式环境，release版本默认读取第一个配置项*/
  static late List<Map<String, String>> configList;

  /*
  第一次赋值会主动调用并返回上次选择的环境
  release下直接返回第一个环境
  * */
  static late LJServiceChangeCallback _serviceChangeCallback;

  static set serviceChangeCallback(LJServiceChangeCallback callback) {
    int _index;
    if (kDebugMode) {
      _index = LJUtil.preferences.getInt('LJDebugIndex') ?? 0;
    } else {
      _index = 0;
    }
    callback(configList[_index]);
    _serviceChangeCallback = callback;
  }

  static LJServiceChangeCallback get serviceChangeCallback =>
      _serviceChangeCallback;

  static OverlayEntry? _entry;

  static void addOverlay(BuildContext context, {String title = 'LJ'}) {
    removeOverlay();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _insertOverlay(context, title));
  }

  static void removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  static void _insertOverlay(BuildContext context, String title) {
    _entry = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
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
              child: quickText(title, 18, Colors.white),
            ),
          ),
        ),
      );
    });
    return Overlay.of(context)?.insert(_entry!);
  }
}
