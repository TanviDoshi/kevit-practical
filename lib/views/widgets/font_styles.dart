import 'dart:ui';

class FontStyles{
  TextStyle fontSemiBoldTextStyle({required textSize, required color}) {
    return TextStyle(
      fontSize: textSize,
      fontFamily: 'semiBoldFont',
      fontWeight: FontWeight.bold,
      color: color,
    );
  }

  TextStyle fontRegularTextStyle({required textSize, required color}) {
    return TextStyle(
      fontSize: textSize,
      fontFamily: 'regularFont',
      fontStyle: FontStyle.normal,
      color: color,
    );
  }

  TextStyle fontMediumTextStyle({required textSize, required color}) {
    return TextStyle(
      fontSize: textSize,
      fontFamily: 'mediumFont',
      color: color,
    );
  }
}