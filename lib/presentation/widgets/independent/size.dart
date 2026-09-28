import 'package:flutter/material.dart';

class ScreenSize {
  static double? _height;
  static double? _width;
  static double? _heightAppbar;

  static double get height => _height ?? 0.0;
  static double get width => _width ?? 0.0;
  static double get heightAppbar => _heightAppbar ?? 0.0;

  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _height = mediaQuery.size.height;
    _width = mediaQuery.size.width;
    _heightAppbar = AppBar().preferredSize.height;
  }
}
