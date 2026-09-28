import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';

class LoadingWidget extends StatelessWidget {
  final Color backgroundColor;

  const LoadingWidget({super.key, this.backgroundColor = colorBackground});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Loading...',
              style: TextStyle(
                fontFamily: fontFamilyMain,
                color: colorSoftGrey,
                fontSize: 10,
              ),
            ),
            SizedBox(height: 8),
            CircularProgressIndicator(
              color: colorSoftGrey.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
