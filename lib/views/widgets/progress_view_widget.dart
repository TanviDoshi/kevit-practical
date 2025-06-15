import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color_constants.dart';

class ProgressViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.colorSecondary),
      strokeWidth: 3.sp,
    );
  }
}