import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

/**
 * 判断动态权限
 * 例如:PermissionGroup.storage
 */
class PermissionUtils {
  static Future<bool> checkStorage() async {
    if (Platform.isIOS) {
      return true;
    } else {
      if (Platform.isAndroid)
        await _requestForAndroid(PermissionGroup.storage);
      PermissionStatus status = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (status == PermissionStatus.granted) return true;
      return false;
    }
  }

  static Future<bool> checkCamera() async {
    // if (Platform.isAndroid)
      await _requestForAndroid(PermissionGroup.camera);
    PermissionStatus status =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (status == PermissionStatus.granted) return true;
    return false;
  }

  static Future<bool> checkPhotos() async {
    if (Platform.isAndroid)
      return true;
    await _requestForAndroid(PermissionGroup.photos);
    PermissionStatus status =
    await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);
    if (status == PermissionStatus.granted) return true;

    return false;
  }

  static Future<bool> checkMicrophone() async {
    if (Platform.isAndroid)
      await _requestForAndroid(PermissionGroup.microphone);
    PermissionStatus status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.microphone);
    if (status == PermissionStatus.granted)
      return true;
    else if (status == PermissionStatus.unknown) {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.microphone]);
      status = permissions[PermissionGroup.microphone];
      if (status == PermissionStatus.granted) return true;
    }

    return false;
  }

  static Future<void> _requestForAndroid(PermissionGroup permission) async {
    // Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([permission]);

//     bool isShow = await PermissionHandler()
//             .shouldShowRequestPermissionRationale(permission);
//     if(isShow == null || !isShow)
// //         await PermissionHandler().openAppSettings();
//       return false;
//     PermissionStatus ps =
//         await PermissionHandler().checkPermissionStatus(permission);
//
//     if (ps == PermissionStatus.granted) {
//       return true;
//     }
//     return false;
  }

// static Future<bool> permissionStorage(
//     List<PermissionGroup> permissionList) async {
//   // 申请权限
//   // 申请权限
//   Map<PermissionGroup, PermissionStatus> permissions =
//   await PermissionHandler().requestPermissions(permissionList);
//   for (int i = 0; i < permissionList.length; i++) {
//     // bool granted = await _requestPermissions(permissionList[i]);
//     // if (!granted)
//       return false;
//   }
//
//   // return true;
// }

//   static Future<bool> _requestPermissions(PermissionGroup permission) async {
// //  申请结果
//     PermissionStatus permissionStatus =
//     await PermissionHandler().checkPermissionStatus(permission);
//
//     if (permissionStatus == PermissionStatus.granted) {
//       return true;
//     } else {
//       bool isShow = Platform.isAndroid ? await PermissionHandler()
//           .shouldShowRequestPermissionRationale(permission) : true;
//       if (!isShow) {
//         await PermissionHandler().openAppSettings();
//         return false;
//       } else {
//         PermissionStatus ps =
//         await PermissionHandler().checkPermissionStatus(permission);
//         if (ps == PermissionStatus.granted) {
//           return true;
//         } else {
//           return _requestPermissions(permission);
//         }
//       }
//     }
//   }
}
