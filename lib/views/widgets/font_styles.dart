import 'package:flutter/material.dart';

class FontStyles{
  static TextStyle fontMediumTextStyle({required textSize, required color}) {
    return TextStyle(
      fontSize: textSize,
      fontFamily: 'mediumFont',
      color: color,
    );
  }

  static TextStyle fontSemiBoldTextStyle({required textSize, required color}) {
    return TextStyle(
      fontSize: textSize,
      fontFamily: 'semiBoldFont',
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  static TextStyle fontRegularTextStyle({required textSize, required color}) {
    return TextStyle(
      fontSize: textSize,
      fontFamily: 'regularFont',
      fontStyle: FontStyle.normal,
      color: color,
    );
  }
}