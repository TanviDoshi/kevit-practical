import 'package:flutter/material.dart';

class TextViewWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  int maxLines = 50;

  TextViewWidget({
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines = 50,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: style,
      textAlign: textAlign,
    );
  }
}