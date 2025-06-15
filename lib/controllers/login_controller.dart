import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';


import '../routes/app_routes.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';


class LoginController extends GetxController{
  late TextEditingController usernameController;
  bool isValidUsername = false;
  String? errorText;
  bool isLoading = false;
  final storage = Get.find<StorageService>();

  @override
  void onInit() {
    usernameController = TextEditingController();
    super.onInit();
  }

  bool isValidateUsername(){
    if(usernameController.text.isEmpty){
      errorText = "Please enter username";
      isValidUsername = false;
    }else if(usernameController.text.length < 3){
      errorText = "Username must be at least 3 characters long";
      isValidUsername = false;
    }else{
      errorText = null;
      isValidUsername = true;
    }
    update();
    return isValidUsername;
  }

  login() async{
    isLoading = true;
    update();

    await storage.setBoolean(Constants.isLogin, true);
    await storage.setString(Constants.userName,usernameController.text);
    isLoading = false;
    navigateToDashboard();
    update();



  }
  navigateToDashboard() {
    Routes.navigateToFeedView();

  }

}