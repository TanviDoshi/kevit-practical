import 'package:flutter/material.dart';

class TextViewWidget extends StatelessWidget {
  String text;
  TextStyle textStyle;
  int maxLines;
  int lines;
  TextAlign textAlign;

  TextViewWidget(
      {super.key, required this.text,
        required this.textStyle,
        this.maxLines = 20,
        this.lines = 1,
        this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
      textAlign: textAlign,
    );
  }
}