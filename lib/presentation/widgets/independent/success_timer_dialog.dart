import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../widgets.dart';

// Class for register timer dialog (dialog with timer). Will use in features/otp/otp_screen.dart
Timer? timerSuccessDialog;

class SuccessTimerDialog extends StatelessWidget {
  final String message;
  final VoidCallback onClosedTap;

  const SuccessTimerDialog({
    super.key,
    required this.message,
    required this.onClosedTap,
  });

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
                timerSuccessDialog!.cancel();
                onClosedTap();
                // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   OderRoutes.login,
                //   (Route<dynamic> route) => false,
                // );
              },
            ),
            Center(
              child: Image(
                image: AssetImage(mainLogo),
                height: ScreenSize.height * 0.13,
              ),
            ),
            // SizedBox(height: ScreenSize.height * 0.02),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(
                marginHorizontal,
                50,
                marginHorizontal,
                ScreenSize.height * 0.04,
              ),
              // padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
              // height: height / 7,
              child: Text(
                'Success',
                style: TextStyle(
                  fontFamily: fontFamilyMain,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: colorTextGreen,
                ),
              ),
            ),
            Container(
              height: ScreenSize.height * 0.15,
              margin: EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/success_circle.png'),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: fontFamilyMain,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future showSuccessTimerDialog(
    BuildContext context,
    String message,
    final VoidCallback routes,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        timerSuccessDialog = Timer(Duration(seconds: 3), routes);
        // and later, before the timer goes off...
        timerSuccessDialog;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.zero,
          backgroundColor: colorWhite,
          content: SuccessTimerDialog(message: message, onClosedTap: routes),
        );
      },
    );
  }
}
