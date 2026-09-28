import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';

/* Widget class for text button (text that can click).  */

class OderButtonText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight fontWeight;
  final bool underline;
  final FontStyle fontStyle;
  final VoidCallback? onClick;
  final EdgeInsetsGeometry? padding;

  const OderButtonText(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight = FontWeight.w500,
    this.onClick,
    this.underline = false,
    this.fontStyle = FontStyle.normal,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      child: TextButton(
        onPressed: onClick,
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(colorTransparent),
          foregroundColor: WidgetStateProperty.all(color),
          padding: WidgetStateProperty.all(padding),
          textStyle: WidgetStateProperty.all(
            TextStyle(
              fontSize: fontSize ?? 14.0,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              fontFamily: fontFamilyMain,
              decoration: underline ? TextDecoration.underline : null,
            ),
          ),
        ),
        child: Text(text, textScaler: TextScaler.linear(scaleFactor)),
      ),
    );
  }
}
