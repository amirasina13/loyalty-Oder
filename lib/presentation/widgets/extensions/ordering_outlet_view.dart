import 'dart:io';

import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

/* Extension class for ordering outlet list(based on merchant). Will use in features/ordering/view/ordering_outlet_view.dart  */
extension View on OutletList {
  Widget getListOutletTile({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    var dist = double.parse(distance!);
    // Color colorCode = Color(Storage().brandColor!);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            InkWell(
              onTap: onTap,
              // child: Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(24),
              //   color: colorBackground,
              // ),
              child: Container(
                // width: width,
                // height: height / 4.7,
                padding:
                    Platform.isIOS
                        ? EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: marginHorizontal,
                        )
                        : EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: marginHorizontal,
                        ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // width: height * 0.025, //width * 0.09,
                      padding: EdgeInsets.only(right: 10),
                      height: ScreenSize.height * 0.02,
                      color: colorTransparent,
                      child: Image(
                        image: AssetImage(
                          'assets/icons/outlet/outlet_black.png',
                        ),
                        // color: colorBlack,
                      ),
                    ),
                    Container(
                      width: ScreenSize.width * 0.65,
                      color: colorBackground,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: colorBlack,
                              fontFamily: fontFamilyMain,
                            ),
                            textScaler: TextScaler.linear(scaleFactor),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              address!,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w400,
                                color: colorValidGray,
                                fontFamily: fontFamilyMain,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child:
                                      isOpen == true
                                          ? Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 7,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colorLightGreen,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: Text(
                                              'Open Now',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: fontFamilyMain,
                                                color: colorTextGreen,
                                              ),
                                            ),
                                          )
                                          : Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 7,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colorLightRed,
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: Text(
                                              'Closed',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: fontFamilyMain,
                                                color: colorTextRed,
                                              ),
                                            ),
                                          ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 6, left: 5),
                                  child:
                                      isOpen == true
                                          ? Text(
                                            end!.isEmpty
                                                ? ''
                                                : 'Closing at $end',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fontFamilyMain,
                                              color: colorDarkGray,
                                            ),
                                          )
                                          : Container(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "${dist.toStringAsFixed(2)}km",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorBlack,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
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
