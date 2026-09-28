// Extended Raised button for Open Flutter E-commerce App
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import '../../../app_setting/app_setting.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

/* Widget class for standardize all button.  */

class OderCustomButton extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback onPressed;
  final String title;
  final IconData? icon;
  final double iconSize;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double? fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final String fontFamily;
  final bool? iconLeading;
  final Color? iconColor;

  const OderCustomButton({
    super.key,
    this.width,
    this.height,
    required this.title,
    required this.onPressed,
    this.icon,
    required this.backgroundColor,
    this.textColor = colorWhite,
    this.borderColor = colorWhite,
    this.iconSize = 18.0,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w400,
    this.borderRadius = 5,
    this.fontFamily = fontFamilyMain,
    this.iconLeading = true,
    this.iconColor = colorWhite,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height ?? ScreenSize.height / 14,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon != null && iconLeading == true
                  ? _buildIcon(theme)
                  : SizedBox(),
              _buildTitle(theme),
              icon != null && iconLeading == false
                  ? _buildIcon(theme)
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.labelLarge?.copyWith(
        backgroundColor: theme.textTheme.labelLarge?.backgroundColor,
        color: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
      ),
      // textScaler: TextScaler.linear(scaleFactor),
      textScaler: TextScaler.linear(scaleFactor),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    if (icon != null) {
      return Padding(
        padding:
            iconLeading == true
                ? EdgeInsets.only(right: 8.0)
                : EdgeInsets.only(left: 8.0),
        child: Icon(icon, size: iconSize, color: iconColor),
      );
    }

    return SizedBox();
  }
}
