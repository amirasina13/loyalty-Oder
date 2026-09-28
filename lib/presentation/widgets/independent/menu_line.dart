import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../widgets.dart';

/* Widget class for custom listTile. Will use in features/settings/view/settings_view.dart.  */
class OderMenuLine extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final VoidCallback onTap;
  final double? fontTitle;
  final FontWeight? fontWeight;

  const OderMenuLine({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.onTap,
    this.fontTitle = 13,
    this.fontWeight = FontWeight.w300,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colorWhite,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: colorBackground,
          alignment: Alignment.centerLeft,
          height: MediaQuery.of(context).size.height / 16,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading:
                icon != null
                    ? Container(
                      width: ScreenSize.height * 0.04, //width * 0.09,
                      height: ScreenSize.height * 0.04,
                      padding: EdgeInsets.all(5),
                      child: icon,
                    )
                    : null,
            title: Text(
              title,
              style: TextStyle(
                color: colorBlackWallet,
                fontSize: fontTitle,
                fontFamily: fontFamilyMain,
                fontWeight: fontWeight,
              ),
              textScaler: TextScaler.linear(scaleFactor),
            ),
            trailing: Icon(Icons.chevron_right, color: mainColor),
          ),
        ),
      ),
    );
  }
}
