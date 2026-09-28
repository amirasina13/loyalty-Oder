import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_setting/app_setting.dart';
import '../../widgets/widgets.dart';

Timer? timerDialog;

class SplashTimerDialog extends StatelessWidget {
  const SplashTimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorTransparent,
        systemNavigationBarColor: colorTransparent,
        //  TempData.currentPage == 'voucherPage'
        //     ? colorWhite
        //     : colorYellowLogo,
      ),
      child: Container(
        alignment: Alignment.center,
        height: ScreenSize.height,
        width: ScreenSize.width,
        child: Scaffold(
          backgroundColor: colorTransparent,
          extendBodyBehindAppBar: true,
          body: Center(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(Storage().welcomeSplash!),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Future showSplashLoginDialog(
    BuildContext context,
    VoidCallback navigation,
  ) {
    return showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        timerDialog = Timer(Duration(seconds: 2), navigation);
        // and later, before the timer goes off...
        timerDialog;

        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.zero,
          backgroundColor: colorGoldButton,
          content: SplashTimerDialog(),
        );
      },
    ).then((value) {});
  }
}
