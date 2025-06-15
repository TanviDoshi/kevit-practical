import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kevit_insta_feed/services/storage_service.dart';
import 'package:kevit_insta_feed/utils/constants.dart';

import '../models/feed_comment.dart';
import '../models/feed_post.dart';

import '../services/database_helper.dart';
import '../utils/color_constants.dart';

class FeedViewController extends GetxController {
  final Map<int, PageController> pageControllers = {};
  List<FeedPost> feedPostList = [];
  bool isLoading = false;
  late TextEditingController commentController;
  bool isCommentLoading = false;
  final storage = Get.find<StorageService>();
  String userName = '';

  @override
  void onInit() async {
    commentController = TextEditingController();
    userName = await storage.getString(Constants.userName) ?? 'User';
    fetchDataFromDB();
    super.onInit();
  }

  fetchDataFromDB() async {
    isLoading = true;
    update();
    Future.delayed(Duration(seconds: 5));
    var data = await DatabaseHelper.instance.fetchPostsWithDetails();
    feedPostList.clear();
    if (data.isNotEmpty) {
      for (var post in data) {
        FeedPost feedPost = FeedPost.fromJson(post);
        feedPostList.add(feedPost);
      }
    } else {
      print("No data found");
    }
    isLoading = false;
    update();
  }

  bool checkValidation(BuildContext context) {
    if (commentController.text.isEmpty) {
      Get.rawSnackbar(
        message: "Please enter a comment",
        snackPosition: SnackPosition.BOTTOM, // Or BOTTOM if you want
        backgroundColor: ColorConstants.colorPrimary,
      );
      return false;
    }
    return true;
  }

  addComment({
    required int feedId,
    required String comment,
    required int listIndex,
  }) async {
    isCommentLoading = true;
    update();
    try {
      Future.delayed(Duration(seconds: 5));
      var data = await DatabaseHelper.instance.insertFeedComment(
        comment: comment,
        feedId: feedId,
        userName: userName,
      );
      if (data != -1) {
        commentController.clear();
        isCommentLoading = false;
        feedPostList[listIndex].comments.add(
          FeedComments(
            id: data,
            comment: comment,
            feedId: feedId,
            userName: userName,
          ),
        );
        update();
      } else {
        Get.rawSnackbar(
          message: "Failed to add comment",
          snackPosition: SnackPosition.BOTTOM, // Or BOTTOM if you want
          backgroundColor: ColorConstants.colorPrimary,
        );
      }
    } catch (e) {
      isCommentLoading = false;
      update();
      Get.rawSnackbar(
        message: "Failed to add comment",
        snackPosition: SnackPosition.BOTTOM, // Or BOTTOM if you want
        backgroundColor: ColorConstants.colorPrimary,
      );
      return;
    }
  }

  likeDislikePost({
    required int feedId,
    required bool isLiked,
    required int listIndex,
  }) async {
    try {
      Future.delayed(Duration(seconds: 5));
      var data = await DatabaseHelper.instance.manageLikeCount(feedId);
      if (data != -1) {
        feedPostList[listIndex].isLikedByUser = !isLiked;
        feedPostList[listIndex].likeCount += isLiked ? -1 : 1;
        update();
      } else {
        Get.rawSnackbar(
          message: "Failed to update like status",
          snackPosition: SnackPosition.BOTTOM, // Or BOTTOM if you want
          backgroundColor: ColorConstants.colorPrimary,
        );
      }
    } catch (e) {
      Get.rawSnackbar(
        message: "Failed to update like status",
        snackPosition: SnackPosition.BOTTOM, // Or BOTTOM if you want
        backgroundColor: ColorConstants.colorPrimary,
      );
    }
  }

  /*Future<void> downloadAndSaveImage(String imageUrl) async {
    // Ask for permissions
    if (await PermissionUtils().getRequiredStoragePermission()) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final Uint8List imageData = response.bodyBytes;
          final result = await ImageGallerySaver.saveImage(
            imageData,
            quality: 100,
            name: "downloaded_image_${DateTime.now().millisecondsSinceEpoch}",
          );
          print("Image saved: $result");
        } else {
          print("Image download failed: ${response.statusCode}");
        }
      } catch (e) {
        print("Error downloading image: $e");
      }
    } else {
      print("Permission not granted");
    }
  }*/
}
