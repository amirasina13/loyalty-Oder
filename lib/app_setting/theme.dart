import 'package:flutter/material.dart';
import 'app_setting.dart';

// FOR CUSTOM THEME

// Ref: Font Weights: https://api.flutter.dev/flutter/dart-ui/FontWeight-class.html
// Ref: Font Weights for TextTheme: https://api.flutter.dev/flutter/material/TextTheme-class.html
class OderTheme {
  static ThemeData of(context) {
    var theme = Theme.of(context);

    return ThemeData(
      useMaterial3: false,
      fontFamily: fontFamilyMain,
      primaryColor: mainColor,
      primaryColorLight: colorDarkGray,
      dividerColor: colorTransparent,
      appBarTheme: theme.appBarTheme.copyWith(
        color: colorWhite,
        iconTheme: const IconThemeData(color: colorBlack),
        titleTextStyle: TextStyle(fontFamily: fontFamilyMain),
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        minWidth: 50,
        buttonColor: mainColor,
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: colorWhite),
      primaryTextTheme: TextTheme().apply(fontFamily: fontFamilyMain),
      textTheme: TextTheme().apply(fontFamily: fontFamilyMain),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: colorMulberry,
      ),
    );
  }
}
