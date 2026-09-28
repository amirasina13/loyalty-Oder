import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../widgets.dart';

/* Widget class for email dialog(Dialog with email icon). Will use in verify_email.  */

// Content of email dialog. Can change design here
class EmailDialog extends StatelessWidget {
  final String mainText;

  const EmailDialog({super.key, required this.mainText});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBackground,
      alignment: Alignment.center,
      height: ScreenSize.height * 0.35,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Show image icon on top
          Expanded(
            flex: 5,
            child: Container(
              height: ScreenSize.height / 4,
              width: ScreenSize.height / 4,
              decoration: BoxDecoration(
                color: colorBackground,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/image/email.webp'),
                ),
              ),
            ),
          ),
          // Show main text that you passed here
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                mainText,
                style: TextStyle(
                  fontSize: 12,
                  color: colorDarkGray,
                  fontFamily: fontFamilyMain,
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(scaleFactor),
              ),
            ),
          ),
          // button to close the dialog
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: OderStyleButton(
                backgroundColor: mainColor,
                height: ScreenSize.height / 14,
                width: ScreenSize.width,
                title: 'OK',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Call this future with text and context. Then will pass to AlertDialog
  static Future showEmailDialog(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          backgroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          content: EmailDialog(mainText: text),
        );
      },
    );
  }
}
