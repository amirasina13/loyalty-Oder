import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';

class OderTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Widget? icon;
  final MainAxisAlignment? mainAxisAlignment;

  const OderTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textStyle,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.borderSide,
    this.icon,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textStyle?.color, // foregroundColor is the text color.
        backgroundColor: backgroundColor,
        overlayColor: colorTransparent,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
          side: borderSide ?? BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: mainAxisAlignment!,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 8.0), // Add spacing between icon and text
          ],
          Text(text, style: textStyle),
        ],
      ),
    );
  }
}
