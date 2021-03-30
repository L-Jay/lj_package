import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/**
 * 判断动态权限
 * 例如:PermissionGroup.storage
 */
class PermissionUtils {
  static Future<bool> permissionStorage(
      List<PermissionGroup> permissionList) async {
    if (Platform.isAndroid) {
      // 申请权限
      for (int i = 0; i < permissionList.length; i++) {
        bool granted = await _requestPermissions(permissionList[i]);
        if (!granted) return false;
      }
    }
    return true;
  }

  static Future<bool> _requestPermissions(PermissionGroup permission) async {
    if (Platform.isAndroid) {
//  申请结果
      PermissionStatus permissionStatus =
          await PermissionHandler().checkPermissionStatus(permission);

      if (permissionStatus == PermissionStatus.granted) {
        return true;
      } else {
        bool isShow = await PermissionHandler()
            .shouldShowRequestPermissionRationale(permission);
        if (!isShow) {
          await PermissionHandler().openAppSettings();
          return false;
        } else {
          PermissionStatus ps =
              await PermissionHandler().checkPermissionStatus(permission);
          if (ps == PermissionStatus.granted) {
            return true;
          } else {
            return _requestPermissions(permission);
          }
        }
      }
    }
  }
}
