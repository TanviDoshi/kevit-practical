import 'package:get/get.dart';

import '../utils/route_constants.dart';


class Routes{
  static Future<void> navigateToFeedView() async {
    Get.offAllNamed(RouteConstants.feedView);
  }
}