import 'package:permission_handler/permission_handler.dart';

class GetPermissions{
  static Future<bool> getCameraPermission() async{
    PermissionStatus permissionStatus = await Permission.camera.status;
    if(permissionStatus.isGranted){
      return true;
    }else if(permissionStatus.isDenied){
      PermissionStatus status = await Permission.camera.request();
      if(status.isGranted){
        return true;
      }else{
        return false;
      }
    }
    return false;
  }

  static Future<bool> getStoragePermission() async{
    PermissionStatus permissionStatus = await Permission.storage.status;
    print("Permission status -- $permissionStatus");
    if(permissionStatus.isGranted){
      return true;
    }else if(permissionStatus.isDenied){
      PermissionStatus status = await Permission.storage.request();
      if(status.isGranted){
        return true;
      }else{
        return false;
      }
    }
    return false;
  }

  ///Gallery Permission for Android 13 (sdk -33) and above
  static Future<bool> getPhotoPermission() async{
    PermissionStatus permissionStatus = await Permission.photos.status;
    print("Permission status -- $permissionStatus");
    if(permissionStatus.isGranted){
      return true;
    }else if(permissionStatus.isDenied){
      PermissionStatus status = await Permission.photos.request();
      if(status.isGranted){
        return true;
      }else{
        return false;
      }
    }
    return false;
  }
}