import 'package:get/get.dart';

import '../controllers/add_feed_view_controller.dart';

class AddFeedViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddFeedController>(() => AddFeedController());
  }

}