import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kevit_insta_feed/controllers/add_feed_view_controller.dart';
import 'package:kevit_insta_feed/utils/color_constants.dart';
import 'package:kevit_insta_feed/views/widgets/button_view_widget.dart';
import 'package:kevit_insta_feed/views/widgets/font_styles.dart';
import 'package:kevit_insta_feed/views/widgets/text_view_widget.dart';

import '../widgets/text_field_widget.dart';

class AddFeedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddFeedController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConstants.colorPrimary,
            title: TextViewWidget(
              text: 'Add Feed',
              textStyle: FontStyles.fontRegularTextStyle(
                textSize: 18.sp,
                color: ColorConstants.colorWhite,
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorConstants.colorWhite,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.sp,
                    left: 16.sp,
                    right: 16.sp,
                  ),
                  child: TextViewWidget(
                    text: "Select Feed Images",
                    textStyle: FontStyles.fontMediumTextStyle(
                      textSize: 14.sp,
                      color: ColorConstants.colorTextPrimary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.pickFeedImages(context);
                      },
                      child: Container(
                        height: 120.sp,
                        width: 120.sp,
                        margin: EdgeInsets.symmetric(
                          horizontal: 16.sp,
                          vertical: 10.sp,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorConstants.colorSecondary,
                          ),
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                        child: Container(
                          height: 60.sp,
                          width: 60.sp,
                          margin: EdgeInsets.symmetric(
                            vertical: 30.sp,
                            horizontal: 30.sp,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorConstants.colorTextPrimary,
                            ),
                            borderRadius: BorderRadius.circular(80.sp),
                          ),
                          child: Icon(
                            Icons.add,
                            color: ColorConstants.colorTextPrimary,
                            size: 40.sp,
                          ),
                        ),
                      ),
                    ),
                    controller.imagePaths.isNotEmpty
                        ? Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 120.sp,
                        child: ListView.builder(
                            padding: EdgeInsets.only(
                              top: 0.sp,
                              right: 16.sp,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const ScrollPhysics(),
                            itemCount: controller.imagePaths.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                padding:
                                EdgeInsets.only(right: 10.sp),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      height: 120.sp,
                                      width: 120.sp,
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(
                                                10.sp)),
                                        child: Image.file(
                                          File(controller
                                              .imagePaths[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        right: -10,
                                        top: -10,
                                        child: GestureDetector(
                                          onTap: () {
                                            controller
                                                .removeDispatchImages(
                                                index);
                                          },
                                          child: Container(
                                            height: 45.sp,
                                            width: 45.sp,
                                            padding:
                                            EdgeInsets.all(5.sp),
                                            decoration: BoxDecoration(
                                                color: ColorConstants
                                                    .colorScreenBackground,
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    40.sp)),
                                            child: Container(
                                                height: 35.sp,
                                                width: 35.sp,
                                                padding:
                                                EdgeInsets.all(
                                                    4.sp),
                                                decoration: BoxDecoration(
                                                    color: ColorConstants.colorTextPrimary,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(40
                                                        .sp)),
                                                child: Center(
                                                    child:Icon(
                                                      Icons.delete,
                                                      color: ColorConstants
                                                          .colorSecondary,
                                                      size: 20.sp,
                                                    )
                                                )),
                                          ),
                                        ))
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                        : const SizedBox()
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.sp,
                    left: 16.sp,
                    right: 16.sp,
                  ),
                  child: TextViewWidget(
                    text: "Feed Caption",
                    textStyle: FontStyles.fontMediumTextStyle(
                      textSize: 14.sp,
                      color: ColorConstants.colorTextPrimary,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: TextFieldWidget(
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textEditingController: controller.captionController,
                    hintText: 'Enter caption',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: Icon(
                        Icons.comment,
                        color: ColorConstants.colorTextSecondary,
                        size: 25.sp,
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(height: 30.sp),
                Center(child: ButtonViewWidget(buttonText: 'Add Feed', buttonWidth: 120.sp, onTap: (){
                  if(controller.checkValidation(context)) {
                    controller.addFeed();
                  }

                }))
              ],
            ),
          ),
        );
      },
    );
  }
}
