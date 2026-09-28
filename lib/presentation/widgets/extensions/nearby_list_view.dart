import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:oder_app/presentation/widgets/independent/size.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../features/ordering/ordering.dart';
// import '../independent/cache_network_image.dart';
import '../widgets.dart';

// Extension class for credit records list. Will use in features/settings/view/history_view.dart
extension View on NearbyOutletList {
  Widget getNearbyListTile({
    required BuildContext context,
    required VoidCallback onTap,
    required OrderingState state,
  }) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                padding:
                    Platform.isIOS
                        ? EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: marginHorizontal,
                        )
                        : EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: marginHorizontal,
                        ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colorBlackTab,
                        fontFamily: fontFamilyMain,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                    // SizedBox(height: ScreenSize.height * 0.),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(right: 5),
                                  height: ScreenSize.height * 0.02,
                                  color: colorTransparent,
                                  child: Image(
                                    image: AssetImage(
                                      'assets/icons/outlet/map_pin.png',
                                    ),
                                    color: colorMulberry,
                                  ),
                                ),
                                Text(
                                  'Address:',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: colorOutletAddressLabelGrey,
                                    fontFamily: fontFamilyMain,
                                  ),
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                              ],
                            ),
                            Container(
                              width: ScreenSize.width * 0.6,
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                address!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w300,
                                  color: colorTextGrey,
                                  fontFamily: fontFamilyMain,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.center,
                          //padding: EdgeInsets.all(8),
                          width: ScreenSize.width * 0.2,
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: CachedImage(imageUrl: image!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Divider(thickness: 1, color: colorLightGray),
      ],
    );
  }
}
