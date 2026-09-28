import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../widgets.dart';

// Class for register timer dialog (dialog with timer). Will use in features/otp/otp_screen.dart

Timer? timerDialog;

class RegisterTimerDialog extends StatelessWidget {
  const RegisterTimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height,
      width: ScreenSize.width,
      padding: EdgeInsets.fromLTRB(
        marginHorizontal,
        ScreenSize.height * 0.006,
        marginHorizontal,
        0,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/background_signin.webp'),
          fit: BoxFit.fill,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.close, color: colorMulberry),
              iconSize: ScreenSize.height * 0.03,
              onPressed: () {
                timerDialog!.cancel();
                // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.login,
                  (Route<dynamic> route) => false,
                );
              },
            ),
            Center(
              child: Image(
                image: AssetImage(mainLogo),
                height: ScreenSize.height * 0.13,
              ),
            ),
            SizedBox(height: ScreenSize.height * 0.02),
            Container(
              height: ScreenSize.height / 3,
              margin: EdgeInsets.fromLTRB(
                marginHorizontal,
                0,
                marginHorizontal,
                20,
              ),
              decoration: BoxDecoration(
                // color: colorBabyBlue,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/image/register-success.webp'),
                ),
              ),
            ),
            // SizedBox(height: height * 0.03),
            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: colorBlack,
                    fontWeight: FontWeight.w300,
                    fontFamily: fontFamilyMain,
                  ),
                  children: const [
                    TextSpan(text: 'Welcome to '),
                    TextSpan(
                      text: appName,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: colorPersianRed,
                        fontFamily: fontFamilyMain,
                      ),
                    ),
                    TextSpan(text: '!'),
                  ],
                ),
              ),
            ),
            SizedBox(height: ScreenSize.width * 0.03),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Your account has been successfully registered.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: colorBlack,
                  fontFamily: fontFamilyMain,
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.linear(scaleFactor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        timerDialog = Timer(Duration(seconds: 3), () {
          // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
          Navigator.of(context).pushNamedAndRemoveUntil(
            OderRoutes.login,
            (Route<dynamic> route) => false,
          );
        });
        // and later, before the timer goes off...
        timerDialog;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.zero,
          backgroundColor: colorWhite,
          content: RegisterTimerDialog(),
        );
      },
    );
  }
}
