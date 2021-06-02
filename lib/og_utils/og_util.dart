import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oralingo_package/og_utils/og_event_bus.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'og_permission.dart';

class OGUtil {
  static SharedPreferences preferences;
  static PackageInfo packageInfo;
  static DeviceInfoPlugin deviceInfo;
  static EventBus eventBus;

  static Future<bool> initInstance() async {
    preferences = await SharedPreferences.getInstance();
    packageInfo = await PackageInfo.fromPlatform();
    deviceInfo = DeviceInfoPlugin();
    eventBus = EventBus();
    return true;
  }

  static Future<String> pickerImage({
    bool useCamera = true,
    bool crop,
    bool userFront = false,
  }) async {
    bool permission = await PermissionUtils.checkStorage();
    if (!permission)
      return null;
    
    if (useCamera)
      permission = await PermissionUtils.checkCamera();
    else
      permission = await PermissionUtils.checkPhotos();

    if (!permission)
      return null;

    PickedFile file = await ImagePicker().getImage(
      source: useCamera ? ImageSource.camera : ImageSource.gallery,
      preferredCameraDevice: userFront ? CameraDevice.front : CameraDevice.rear,
    );

    if (file == null)
      return null;

    if (crop == null || !crop)
      return file.path;
    else
      return await cropImage(file.path);
  }

  static Future<String> cropImage(String imagePath, {
    double ratioX = 1,
    double ratioY = 1,
  }) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imagePath,
      aspectRatio: CropAspectRatio(
        ratioX: ratioX,
        ratioY: ratioY,
      ),
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      // ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: "剪裁",
        toolbarColor: Colors.transparent,
        // toolbarWidgetColor: Colors.transparent,
        // initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: true,
        hideBottomControls: true,
        cropGridRowCount: 0,
        cropGridColumnCount: 0,
      ),
      compressQuality: 100,
      cropStyle: CropStyle.rectangle,
      iosUiSettings: IOSUiSettings(
        title: '剪裁',
        cancelButtonTitle: '取消',
        doneButtonTitle: '完成',
      ),
    );

    return croppedFile.path;
  }
}
