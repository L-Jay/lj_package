import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lj_event_bus.dart';
import 'lj_permission.dart';

class LJUtil {
  static SharedPreferences preferences;
  static PackageInfo packageInfo;
  static AndroidDeviceInfo androidDeviceInfo;
  static IosDeviceInfo iosDeviceInfo;
  static EventBus eventBus;
  static bool isEnglish = false;

  static Future<bool> initInstance() async {
    preferences = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();
    androidDeviceInfo =
        Platform.isIOS ? null : await DeviceInfoPlugin().androidInfo;
    iosDeviceInfo = Platform.isIOS ? await DeviceInfoPlugin().iosInfo : null;
    eventBus = EventBus();
    return true;
  }

  static ImagePicker _picker = ImagePicker();

  static Future<String> pickerImage({
    bool useCamera = true,
    bool crop,
    bool userFront = false,
  }) async {
    bool permission = await PermissionUtils.checkStorage();
    if (!permission) return null;

    if (useCamera)
      permission = await PermissionUtils.checkCamera();
    else
      permission = await PermissionUtils.checkPhotos();

    if (!permission) return null;

    XFile file = await _picker.pickImage(
      source: useCamera ? ImageSource.camera : ImageSource.gallery,
      preferredCameraDevice: userFront ? CameraDevice.front : CameraDevice.rear,
    );
    // PickedFile file = await ImagePicker.platform.pickImage(
    //   source: useCamera ? ImageSource.camera : ImageSource.gallery,
    //   preferredCameraDevice: userFront ? CameraDevice.front : CameraDevice.rear,
    // );

    if (file == null) return null;

    if (crop == null || !crop)
      return file.path;
    else
      return await cropImage(file.path);
  }

  static Future<String> cropImage(
    String imagePath, {
    double ratioX = 1,
    double ratioY = 1,
  }) async {
    CroppedFile croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(
        ratioX: ratioX,
        ratioY: ratioY,
      ),
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      // ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: isEnglish ? 'Tailoring' : "剪裁",
          toolbarColor: Colors.transparent,
          // toolbarWidgetColor: Colors.transparent,
          // initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          hideBottomControls: true,
          cropGridRowCount: 0,
          cropGridColumnCount: 0,
        ),
        IOSUiSettings(
          title: isEnglish ? 'Tailoring' : '剪裁',
          cancelButtonTitle: isEnglish ? 'Cancel' : '取消',
          doneButtonTitle: isEnglish ? 'Done' : '完成',
        ),
      ],
      compressQuality: 100,
      cropStyle: CropStyle.rectangle,
    );

    return croppedFile.path;
  }
}
