import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../../util/utils.dart';
import '../widgets.dart';

// Class for rich text. Will use in features/register/view/profile_view.dart
class OderRichText extends StatelessWidget {
  final String oneText;
  final String? twoText;
  final String? threeText;
  final String? fourText;
  final String? addingText;
  final String? title1;
  final String? title2;
  final String? url1;
  final String? url2;

  const OderRichText({
    super.key,
    required this.oneText,
    this.twoText,
    this.threeText,
    this.fourText,
    this.addingText,
    this.title1,
    this.title2,
    this.url1,
    this.url2,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle = TextStyle(
      color: colorBlack,
      fontSize: 10,
      fontFamily: fontFamilyMain,
    );
    TextStyle linkStyle = TextStyle(
      color: colorLightBlue,
      fontSize: 10,
      fontFamily: fontFamilyMain,
    );

    return RichText(
      textAlign: TextAlign.justify,
      text: TextSpan(
        style: defaultStyle,
        children: <TextSpan>[
          TextSpan(text: oneText),
          TextSpan(
            text: addingText,
            style: TextStyle(
              fontSize: 10,
              color: mainColor,
              fontFamily: fontFamilyMain,
            ),
          ),
          TextSpan(
            text: twoText,
            style: linkStyle,
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    _launchURL(context, title1, url1);
                  },
          ),
          TextSpan(text: threeText),
          TextSpan(
            text: fourText,
            style: linkStyle,
            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    _launchURL(context, title2, url2);
                  },
          ),
        ],
      ),
    );
  }

  _launchURL(BuildContext context, title, url) {
    Navigator.push(
      context,
      NoAnimationPageRoute(
        builder: (context) {
          // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
          return WidgetWebView(widgetUrl: url, title: title);
        },
      ),
    );
  }
}
