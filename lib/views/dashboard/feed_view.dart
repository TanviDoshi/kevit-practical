import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../controllers/feed_view_controller.dart';
import '../../models/feed_comment.dart';
import '../../models/feed_post.dart';
import '../../utils/color_constants.dart';
import '../../utils/date_utils.dart';
import '../../utils/permission_utils.dart';
import '../widgets/font_styles.dart';
import '../widgets/progress_view_widget.dart';
import '../widgets/text_view_widget.dart';
class FeedView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => FeedViewState();

}
class FeedViewState extends State<FeedView> with WidgetsBindingObserver{

  FeedViewController controller = Get.put(FeedViewController());
  @override
  void initState() {

    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state -- $state');
    if (state == AppLifecycleState.resumed) {
      print('App resumed');
      controller.fetchDataFromDB();
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedViewController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                 controller.navigateToAddFeedView();
                                },
                                child: SvgPicture.asset(
                                  'assets/images/ic_create_post.svg',
                                  width: 25.sp,
                                  height: 25.sp,
                                ),
                              ),
                              SizedBox(width: 8.sp),
                              IconButton(onPressed: (){
                                controller.fetchDataFromDB();
                              }, icon: Icon(Icons.refresh,color: ColorConstants.colorTextPrimary,size: 30.sp,)),
                            ],
                          ),
                          TextViewWidget(text: 'Feed', textStyle: FontStyles.fontSemiBoldTextStyle(textSize: 20.sp,color: ColorConstants.colorSecondary)),
                          Row(
                            children: [
                              SizedBox(width: 38.sp,),
                              GestureDetector(
                                onTap: (){
                                  showLogoutDialog(onLogoutTap: (){
                                    controller.logoutUser();
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/images/ic_logout.svg',
                                  width: 25.sp,
                                  height: 25.sp,
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Expanded(child: ListView.builder(
                      itemCount: controller.feedPostList.length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),

                      itemBuilder: (context, index) {
                        controller.pageControllers.putIfAbsent(
                          index,
                              () => PageController(viewportFraction: 1),
                        );
                        var currentPost = controller.feedPostList[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/ic_user.png',
                                    height: 40.sp,
                                    width: 40.sp,
                                  ),
                                  SizedBox(width: 8.sp),
                                  TextViewWidget(
                                    text: currentPost.username,
                                    textStyle: FontStyles.fontRegularTextStyle(textSize: 14.sp, color: ColorConstants.colorTextPrimary),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(
                                height: Get.width,
                                width:Get.width,
                                child: PageView.builder(itemBuilder: (context, pageIndex) {
                                  return CachedNetworkImage(imageUrl:currentPost.images[pageIndex].imagePath,
                                    height: Get.width,
                                    width:Get.width,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Image.file(
                                      File(currentPost.images[pageIndex].imagePath),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Text('Image not found');
                                      },
                                    ));
                                   /* Image.asset(
                                    'assets/images/img_dummy_2.jpg',
                                    height: Get.width,
                                    width:Get.width,
                                    fit: BoxFit.cover,
                                  );*/
                                }, itemCount: currentPost.images.length, controller: controller.pageControllers[index]
                                )
                            ),
                            Center(
                              child: Padding(
                                padding:EdgeInsets.symmetric(horizontal: 5.sp,vertical: 8.sp),
                                child: SmoothPageIndicator(
                                  controller: controller.pageControllers[index]!, // PageController
                                  count: currentPost.images.length, // Number of images
                                  effect: WormEffect(
                                      dotHeight: 7.sp,
                                      dotWidth: 7.sp,
                                      spacing: 5.sp,
                                      activeDotColor: ColorConstants.colorSecondary,
                                      dotColor: ColorConstants.colorTextSecondary),
                                ),
                              ),
                            ),

                            Padding(
                              padding:EdgeInsets.symmetric(horizontal: 8.sp),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          controller.likeDislikePost(feedId: currentPost.id, isLiked: currentPost.isLikedByUser, listIndex: index);

                                        },
                                        child: SvgPicture.asset(
                                          currentPost.isLikedByUser ?'assets/images/ic_heart_fill.svg' :'assets/images/ic_heart.svg',
                                          width: 25.sp,
                                          height: 25.sp,
                                          colorFilter: ColorFilter.mode(
                                            currentPost.isLikedByUser ? ColorConstants.colorSecondary : ColorConstants.colorTextPrimary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.sp),
                                      TextViewWidget(
                                        text: currentPost.likeCount.toString(),
                                        textStyle: FontStyles.fontRegularTextStyle(textSize: 14.sp, color: ColorConstants.colorTextSecondary),
                                      ),
                                      SizedBox(width: 12.sp),
                                      GestureDetector(
                                        onTap: (){
                                          showCommentsSheet(context,currentPost,index);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/ic_comment.svg',
                                          width: 25.sp,
                                          height: 25.sp,
                                          colorFilter: ColorFilter.mode(
                                            ColorConstants.colorTextPrimary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.sp),
                                      TextViewWidget(
                                        text: currentPost.comments.length.toString(),
                                        textStyle: FontStyles.fontRegularTextStyle(textSize: 14.sp, color: ColorConstants.colorTextSecondary),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap:() async{
                                      if(await PermissionUtils.getDownloadStoragePermission() == true) {
                                        controller.saveToGallery(
                                         currentPost.images[0].imagePath,
                                        );
                                      } else {
                                        Get.rawSnackbar(
                                          message: "Storage permission is required to download the image.",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: ColorConstants.colorPrimary,
                                        );
                                      }
                        },
                                    child: SvgPicture.asset(
                                      'assets/images/ic_download.svg',
                                      width: 25.sp,
                                      height: 25.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           currentPost.caption.isNotEmpty ? Padding(padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 8.sp),
                              child: TextViewWidget(
                                text: currentPost.caption ?? '',
                                textStyle: FontStyles.fontRegularTextStyle(textSize: 13.sp, color: ColorConstants.colorTextPrimary),
                                textAlign: TextAlign.start,
                                maxLines: 3,
                              ),

                            ) : SizedBox(height: 8.sp),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 1.sp),
                              child: TextViewWidget(
                                text: DateUtil.toPrettyDateFromIso(currentPost.createdAt ?? ''),
                                textStyle: FontStyles.fontRegularTextStyle(textSize: 12.sp, color: ColorConstants.colorTextSecondary),
                                textAlign: TextAlign.start,
                                maxLines: 3,
                              ),

                            ),
                            SizedBox(
                              height: 10.sp,
                            ),

                          ],
                        );
                        /*return ListTile(
                          leading: Image.asset('assets/images/ic_user.png',height: 45.sp,width: 45.sp,),
                          title: TextViewWidget(
                            text: 'tanu3499',
                            textStyle: FontStyles.fontSemiBoldTextStyle(textSize: 16.sp, color: ColorConstants.colorPrimary),
                          ),
                          subtitle: TextViewWidget(
                            text: 'Posted a new photo',
                            textStyle: FontStyles.fontRegularTextStyle(textSize: 14.sp, color: ColorConstants.colorTextSecondary),
                          ),
                        );*/
                      }
                    )),
                  ],
                ),
                controller.isLoading
                    ? Center(child: ProgressViewWidget())
                    : SizedBox.shrink(),
              ],
            )
          ),
        );
      }
    );

  }

  showLogoutDialog({required Function() onLogoutTap}) {
    return Get.dialog(Dialog(
      backgroundColor: ColorConstants.colorTextWhite,
      insetPadding: EdgeInsets.symmetric(horizontal: 10.sp),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextViewWidget(
            text: 'Logout',
            textStyle: FontStyles.fontMediumTextStyle(
                textSize: 18.sp, color: ColorConstants.colorTextPrimary),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.sp),
            child: TextViewWidget(
              text: 'Are you sure you want to logout ?',
              textStyle: FontStyles.fontRegularTextStyle(
                  textSize: 16.sp, color: ColorConstants.colorTextPrimary),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: TextViewWidget(
                      text: "Cancel",
                      textStyle: FontStyles.fontRegularTextStyle(
                          textSize: 14.sp,
                          color: ColorConstants.colorTextPrimary)),
                ),
                SizedBox(
                  width: 16.sp,
                ),
                GestureDetector(
                  onTap: () {
                    onLogoutTap();
                    Get.back();
                  },
                  child: TextViewWidget(
                      text: "Logout",
                      textStyle: FontStyles.fontRegularTextStyle(
                          textSize: 14.sp, color: ColorConstants.colorPrimary)),
                )
              ],
            ),
          )
        ]),
      ),
    ));
  }


  void showCommentsSheet(BuildContext context,FeedPost currentItem,int index) {
    final controller = Get.put(FeedViewController());
    Get.bottomSheet(
      GetBuilder<FeedViewController>(builder: (_) {
        return Container(
          constraints: BoxConstraints(
            minHeight: 200.sp, // Minimum height
            maxHeight: MediaQuery.of(context).size.height * 0.7, // Max height
          ),
          decoration: BoxDecoration(
            color: Color(0xFFF4F5F7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.sp)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.sp, right: 16.sp, top: 16.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextViewWidget(
                        text: 'Comments',
                        textStyle: FontStyles.fontRegularTextStyle(
                            textSize: 16.sp,
                            color: ColorConstants.colorTextPrimary)),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                          padding: EdgeInsets.all(2.sp),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.sp),
                              border: Border.all(
                                  color: ColorConstants.colorTextSecondary)),
                          child: Icon(
                            Icons.close_sharp,
                            color: ColorConstants.colorTextPrimary,
                          )),
                    )
                  ],
                ),
              ),
              Divider(),
              Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      controller.isLoading
                          ? Center(child: ProgressViewWidget())
                          : currentItem.comments.isEmpty
                              ? Center(
                                  child: TextViewWidget(
                                    text: "No comments found",
                                    textStyle: FontStyles.fontRegularTextStyle(
                                        textSize: 14.sp,
                                        color: ColorConstants.colorTextSecondary),
                                  ),
                                )
                              :
                      ListView.builder(
                          itemCount: currentItem.comments.length,
                          itemBuilder: (_, index) {
                            var currentComment =
                            currentItem.comments[index];
                            return CommentTile(currentComment);
                          })

                    ],
                  )),
              Divider(),
              Container(
                color: Color(0xFFF6F6F6),
                child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Row(
                    children: [
                     /* ClipRRect(
                        borderRadius: BorderRadius.circular(30.sp),
                        child: ImageViewWidget(
                          imageUrl: controller.userData?.imageUrl ?? "",
                          width: 30.sp,
                          height: 30.sp,
                          boxFit: BoxFit.cover,
                        ),
                      ),*/
                      SizedBox(width: 8.sp),
                      Expanded(
                        child: TextField(
                          cursorColor: ColorConstants.colorSecondary,
                          keyboardType: TextInputType.text,
                          controller:controller.commentController,
                          onChanged: (value) {
                         //   controller.updateCommentText(value);
                          },
                          decoration: InputDecoration(
                            fillColor: ColorConstants.colorOffWhite,
                            filled: true,
                            hintText: "Add your comment here...",
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 12.sp),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // No border
                              borderRadius:
                              BorderRadius.circular(8.sp), // Corner radius
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.sp,
                      ),
                      controller.isCommentLoading == true
                          ? ProgressViewWidget()
                         :
                    GestureDetector(
                        onTap: () {
                          if (controller.checkValidation(context)) {
                            controller.addComment(
                              feedId: currentItem.id,
                              comment : controller.commentController.text,
                              listIndex: index
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/images/ic_send.svg",
                            width: 25.sp,
                            height: 25.sp,
                            colorFilter: ColorFilter.mode(
                              ColorConstants.colorSecondary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    ).whenComplete(() {
      if (Get.isRegistered<FeedViewController>()) {
        Get.delete<FeedViewController>();
      }
    });
  }

}

class CommentTile extends StatelessWidget {
  FeedComments commentData;

  CommentTile(this.commentData);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.sp, right: 16.sp, bottom: 24.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextViewWidget(
              text: commentData.userName ?? '',
              textStyle: FontStyles.fontRegularTextStyle(
                  textSize: 13.sp,
                  color: ColorConstants.colorTextSecondary),),
          SizedBox(
            height: 5.sp,
          ),
          TextViewWidget(
            text: commentData.comment ?? "",
            textStyle: FontStyles.fontRegularTextStyle(
                textSize: 14.sp, color: ColorConstants.colorTextPrimary),
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }


}