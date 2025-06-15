import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'get_permissions.dart';

class PermissionUtils{
  static Future<bool> getDownloadStoragePermission() async {
    bool storageStatus = false;
    if (Platform.isAndroid) {
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if (deviceInfo.version.sdkInt >= 30) {
        print("permission request = 1");
        storageStatus = true;
      } else {
        print("permission request = 2");
        storageStatus = await getStoragePermission();
      }
    } else if (Platform.isIOS) {
      print("permission request = 3");
      storageStatus = await getStoragePermission();
    }
    return storageStatus;
  }

  static Future<bool> getStoragePermission() async {
    PermissionStatus permissionStatus = await Permission.storage.status;
    print("Permission status -- $permissionStatus");
    if (permissionStatus.isGranted) {
      return true;
    } else if (permissionStatus.isDenied) {
      PermissionStatus status = await Permission.storage.request();
      print("Permission new status -- $status");
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  static Future<bool> getRequiredStoragePermission() async{
    bool storageStatus = false;
    if(Platform.isAndroid){
      final deviceInfo = await DeviceInfoPlugin().androidInfo;
      if(deviceInfo.version.sdkInt >=33){
        storageStatus = true;
      }
      else if (deviceInfo.version.sdkInt > 32) {
        storageStatus =
        await GetPermissions.getPhotoPermission();
      }else{
        storageStatus =
        await GetPermissions.getStoragePermission();
      }
    }else if(Platform.isIOS){
      storageStatus =
      await GetPermissions.getStoragePermission();
    }
    return storageStatus;

  }
}