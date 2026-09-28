import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

/* Extension class for merchant(brand) list. Will use in features/ordering/view/ordering_view.dart  */
extension View on MerchantList {
  Widget getListBrandTile({
    required BuildContext context,
    required VoidCallback onTap,
    // required OrderingState state,
  }) {
    Color hexColor;

    if (color!.substring(1).isEmpty ||
        !color!.startsWith('#') ||
        color!.length != 7) {
      hexColor = colorBackground;
    } else {
      hexColor = Color(int.parse('0xFF${color!.substring(1)}'));
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 0, left: 5, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container for the image with fixed height
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 1),
              decoration: BoxDecoration(
                color: hexColor,
                // border: Border.all(width: 1, color: colorLightGray),
                // borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: SizedBox(
                height: ScreenSize.height * 0.11,
                width: ScreenSize.width * 0.7,
                // padding: EdgeInsets.all(8),
                child: Center(
                  child: CachedImage(
                    imageUrl: image!,
                    boxFit:
                        BoxFit.contain, // Adjust how the image fits in the box
                  ),
                ),
              ),
            ),
            // Container for the text and other information
            SizedBox(
              width: ScreenSize.width * 0.65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colorBlack,
                      fontFamily: fontFamilyMain,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textScaler: TextScaler.linear(scaleFactor),
                  ),
                  // SizedBox(height: 5),
                  total == 0
                      ? SizedBox()
                      : Container(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: 3),
                              height: ScreenSize.height * 0.015,
                              color: colorTransparent,
                              child: Image(
                                image: AssetImage(
                                  'assets/icons/outlet/outlet_black.png',
                                ),
                                color: colorBlackTab,
                              ),
                            ),
                            Text(
                              '$total outlet(s)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: colorBlackTab,
                                fontFamily: fontFamilyMain,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
