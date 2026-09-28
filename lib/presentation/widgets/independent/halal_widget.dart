import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';

class HalalWidget extends StatelessWidget {
  final String muslimCategory;
  final bool? isCircle;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? colorBlendMode;
  final bool? isText;

  const HalalWidget({
    super.key,
    required this.muslimCategory,
    this.isCircle = false,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.isText = false,
  });

  @override
  Widget build(BuildContext context) {
    return _getHalalLogo(context, muslimCategory);
  }

  Widget _getHalalLogo(BuildContext context, String muslimCategory) {
    if (muslimCategory == "halal") {
      return !isText!
          ? Image(
            color: color,
            colorBlendMode: colorBlendMode,
            width: width,
            image: AssetImage(
              !isCircle!
                  ? 'assets/icons/icon_halal.webp'
                  : 'assets/icons/halal_circle.webp',
            ),
          )
          : Text(
            'Halal',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              fontFamily: fontFamilyMain,
            ),
          );
    } else if (muslimCategory == "imesra") {
      return !isText!
          ? Image(
            color: color,
            colorBlendMode: colorBlendMode,
            width: width,
            image: AssetImage(
              !isCircle!
                  ? 'assets/icons/icon_imesra.webp'
                  : 'assets/icons/imesra_circle.webp',
            ),
          )
          : Text(
            'iMesra',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              fontFamily: fontFamilyMain,
            ),
          );
    } else if (muslimCategory == "mFriendly") {
      return !isText!
          ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Image(
              color: color,
              colorBlendMode: colorBlendMode,
              width: width! + 5,
              image: AssetImage('assets/icons/icon_muslim_friendly.webp'),
            ),
          )
          : Text(
            'Muslim Friendly',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
              fontFamily: fontFamilyMain,
            ),
          );
    } else {
      return SizedBox();
    }
  }
}
