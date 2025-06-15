import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StorageService extends GetxService{
  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<void> setBoolean(String key, bool value) async{
    await _prefs.setBool(key, value);
  }

  Future<bool?> getBoolean(String key) async{
    return _prefs.getBool(key);
  }

  Future<void> setString(String key,String value) async{
    await _prefs.setString(key, value);
  }

  Future<String?> getString(String key) async{
    return _prefs.getString(key);
  }

  Future<void> setInt(String key,int value) async{
    await _prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async{
    return _prefs.getInt(key);
  }

  Future<void> clear() async{
    _prefs.clear();
  }


}