import 'package:get/get.dart';
import '../../utils/constants.dart';
import '../services/storage_service.dart';



class CheckAuthController extends GetxController{
  final storage = Get.find<StorageService>();
  RxBool isLogin = false.obs;
  @override
  void onInit() async {
    checkLoginStatus();
    super.onInit();
  }

  Future<void> checkLoginStatus() async {
    var isLog = await storage.getBoolean(Constants.isLogin);
    if(isLog != null){
      isLogin.value = isLog;

    }
  }

}