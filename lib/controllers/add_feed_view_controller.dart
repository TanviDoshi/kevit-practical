import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kevit_insta_feed/models/feed_images.dart';
import 'package:kevit_insta_feed/models/feed_post.dart';

import '../services/database_helper.dart';
import '../services/storage_service.dart';
import '../utils/color_constants.dart';
import '../utils/constants.dart';
import '../utils/imagepicker_service.dart';

class AddFeedController extends GetxController {
  List<String> imagePaths = [];
  bool isLoading = false;
  late TextEditingController captionController;

  final storage = Get.find<StorageService>();
  String userName = '';

  @override
  void onInit() async {
    captionController = TextEditingController();
    userName = await storage.getString(Constants.userName) ?? 'User';
    super.onInit();
  }

  Future<void> pickFeedImages(BuildContext context) async {
    var image = await ImagePickerService().chooseImageFile(context);
    if (image == null) {
      print("image null");
    } else {
      var imagePath = image.path;
      imagePaths.add(imagePath);
      update();
    }
  }

  removeDispatchImages(int index) {
    if (index >= 0 && index < imagePaths.length) {
      imagePaths.removeAt(index);
      update();
    } else {
      print("Index out of range");
    }
  }

  bool checkValidation(BuildContext context) {
    if (imagePaths.isEmpty) {
      Get.rawSnackbar(
        message: "Please select at least one image",
        snackPosition: SnackPosition.BOTTOM, // Or BOTTOM if you want
        backgroundColor: ColorConstants.colorPrimary,
      );
      return false;
    }
    return true;
  }

  addFeed() async {
    print('Adding feed with images: $imagePaths');
    isLoading = true;
    update();
    Future.delayed(Duration(seconds: 5));
    List<FeedPost> feedPostList = [];
    List<FeedImages> feedImagesList = [];
    for (var imagePath in imagePaths) {
      feedImagesList.add(FeedImages(id: 0,imagePath: imagePath,feedId: 0));
    }

    var postData =  FeedPost(
        id: 0,
        username: userName,
        caption: captionController.text,
        likeCount: 0,
        isLikedByUser: false,
        createdAt: '',
        images: feedImagesList,
        comments: [],
      );

    var data = await DatabaseHelper.instance.insertFeedPostData(postData);
    print("Data inserted: $data");
    if (data != -1) {
      Get.rawSnackbar(
        message: "Feed added successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorConstants.colorPrimary,
      );
    } else {
      Get.rawSnackbar(
        message: "Failed to add feed ! Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: ColorConstants.colorPrimary,
      );
    }
    isLoading = false;
    update();
  }
}
