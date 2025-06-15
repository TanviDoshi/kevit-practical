import 'package:get/get.dart';

import '../utils/route_constants.dart';


class Routes{
  static Future<void> navigateToFeedView() async {
    Get.offAllNamed(RouteConstants.feedView);
  }
  static Future<void> navigateToLoginView() async {
    Get.offAllNamed(RouteConstants.login);
  }
  static Future<dynamic> navigateToAddFeedView() async {
    Get.toNamed(RouteConstants.addFeedView);
  }
}