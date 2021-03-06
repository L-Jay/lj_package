import 'package:flutter/material.dart';
import 'lj_define.dart';

class RouterManager {
  static GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();

  /*路由表*/
  static Map routes = <String, WidgetBuilder>{};

  /*需要验证登录态的路由*/
  static List verifyLoginPageList = [];

  /*全局pop callback，返回都会调用*/
  static VoidCallback? globalPopCallback;

  /*获取登录状态*/
  static bool Function()? getLoginStatus;

  static Future<bool> Function(BuildContext context)? doLogin;

  static pushNamed<T>(
      BuildContext context,
      String routeName, {
        Object? arguments,
        ObjectCallback<T>? popCallback,
      }) async {
    bool loginStatus = getLoginStatus?.call() as bool;
    if (verifyLoginPageList.contains(routeName) && !loginStatus) {
      bool? loginResult = await doLogin?.call(context);
      if (loginResult == true)
        Navigator.pushNamed(context, routeName, arguments: arguments)
            .then((value) {
          popCallback?.call(value as T);
          globalPopCallback?.call();
        });
    } else {
      Navigator.pushNamed(context, routeName, arguments: arguments)
          .then((value) {
        popCallback?.call(value as T);
        globalPopCallback?.call();
      });
    }
  }
}

extension StateArguments on State {
  Object? get argument {
    return ModalRoute.of(this.context)?.settings.arguments;
  }

  Map? get argumentMap {
    return ModalRoute.of(this.context)?.settings.arguments as Map;
  }
}

extension StatelessWidgetArguments on StatelessWidget {
  Object? argument(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments;
  }

  Map? argumentMap(BuildContext context) {
    return ModalRoute.of(context)?.settings.arguments as Map;
  }
}

MaterialPageRoute pageRoute(Widget page) {
  return MaterialPageRoute(
      builder: (context) => page,
  );
}
