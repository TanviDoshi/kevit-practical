import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kevit_insta_feed/utils/permission_utils.dart';
import 'package:kevit_insta_feed/views/widgets/font_styles.dart';
import 'package:kevit_insta_feed/views/widgets/text_view_widget.dart';


import 'color_constants.dart';
import 'get_permissions.dart';

class ImagePickerService{
  Future<PickedFile> pickImage({required ImageSource source}) async{
    final xFileSource = await ImagePicker().pickImage(source: source);
    return PickedFile(xFileSource!.path);
  }

  Future<File?> chooseImageFile(BuildContext context) async{
    Future<void> openSource(ImageSource source) async{
      final file = await pickImage(source: source);
      File selected = File(file.path);
      if(await selected.exists()){
        Get.back(result: selected);
      }else{
        Get.back();
      }
    }
    try{
      return await showDialog(context: context, builder:(mContext){
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.sp)
            ),
            child: Wrap(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.sp),
                          child: TextViewWidget(
                              text: "choose Option",
                              textStyle: FontStyles.fontRegularTextStyle(
                                  textSize: 16.sp,
                                  color: ColorConstants.colorTextPrimary
                              )
                          ),
                        ),
                        Divider(
                            height: 1.sp,
                            thickness: 1.sp,
                            endIndent: 0,
                            color: ColorConstants.colorTextSecondary
                        ),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(mContext).size.width,
                            alignment: Alignment.center,
                            child: Padding(
                                padding: EdgeInsets.all(15.sp),
                                child: TextViewWidget(
                                    text: "Camera",
                                    textStyle: FontStyles.fontRegularTextStyle(
                                        textSize: 14.sp,
                                        color: ColorConstants.colorTextPrimary
                                    )
                                )
                            ),
                          ),
                          onTap: () async {
                            final bool cameraStatus
                            = await GetPermissions.getCameraPermission();
                            if(cameraStatus){
                              openSource(ImageSource.camera);
                            }
                          },
                        ),
                        Divider(
                          height: 1.sp,
                          thickness: 1.sp,
                          endIndent: 0,
                          color: ColorConstants.colorTextSecondary,
                        ),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(mContext).size.width,
                            alignment: Alignment.center,
                            child: Padding(
                                padding: EdgeInsets.all(15.sp),
                                child: TextViewWidget(
                                    text:"Gallery",
                                    textStyle: FontStyles.fontRegularTextStyle(
                                        textSize: 14.sp,
                                        color: ColorConstants.colorTextPrimary
                                    )
                                )
                            ),
                          ),
                          onTap: () async {
                            var galleryStatus = await PermissionUtils.getRequiredStoragePermission();
                            if(galleryStatus){
                              openSource(ImageSource.gallery);
                            }
                          },
                        ),
                        Divider(
                            height: 1.sp,
                            thickness: 1.sp,
                            endIndent: 0,
                            color: ColorConstants.colorTextSecondary
                        ),
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(mContext).size.width,
                            alignment: Alignment.center,
                            child: Padding(
                                padding: EdgeInsets.all(15.sp),
                                child:TextViewWidget(text:'Cancel', textStyle: FontStyles.fontSemiBoldTextStyle(textSize: 14.sp, color: ColorConstants.colorSecondary))
                            ),
                          ),
                          onTap: () async {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ]));
      });
    }catch(e){

    }
    return null;
  }
}