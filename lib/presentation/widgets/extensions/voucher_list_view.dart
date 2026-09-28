import 'dart:io';

import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on Voucher {
  Widget getVoucherListTile({
    required BuildContext context,
    required VoidCallback onTap,
    // required bool past,
  }) {
    var formatter = DateFormat(appDateFormat);
    var dateExpired = formatter.format(DateTime.parse(expired!));

    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenSize.height * 0.08,
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: CachedImage(imageUrl: image!),
                        ),
                      ),
                      isMuslim == true
                          ? Positioned(
                            right: 0,
                            top: 3,
                            child: HalalWidget(
                              muslimCategory: muslimCategory!,
                              width: ScreenSize.width * 0.04,
                            ),
                          )
                          : SizedBox(),
                    ],
                  ),
                ),
                Flexible(
                  // flex: 2,
                  child: Container(
                    height: ScreenSize.height * 0.09,
                    margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                    // padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: colorTransparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // height: height * 0.03,
                          // padding: EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.topLeft,
                          // color: AppColors.deepYellow,
                          child: Text(
                            name!,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: fontFamilyMain,
                              fontWeight: FontWeight.w500,
                              color: colorBlackText,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          // height: height * 0.062,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.topLeft,
                          color: colorTransparent,
                          child: Text(
                            desc!,
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: fontFamilyMain,
                              fontWeight: FontWeight.w500,
                              color: colorTextGrey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              // height: height * 0.062,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              alignment: Alignment.bottomLeft,
                              color: colorTransparent,
                              child: Text(
                                'x$quantity',
                                // textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: fontFamilyMain,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: ScreenSize.height / 13,
                  width: ScreenSize.width * 0.18,
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Valid Until',
                        style: TextStyle(
                          fontSize: 8,
                          fontFamily: fontFamilyMain,
                          fontWeight: FontWeight.w300,
                          color: colorTextGrey,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: ScreenSize.height * 0.005),
                      Text(
                        dateExpired,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: fontFamilyMain,
                          fontWeight: FontWeight.w500,
                          color: colorBlackText,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(bottom: 5),
            child: InkWell(
              onTap: onTap,
              child: Container(
                width:
                    Platform.isIOS
                        ? ScreenSize.width * 0.25
                        : ScreenSize.width * 0.28,
                height:
                    Platform.isIOS
                        ? ScreenSize.width * 0.07
                        : ScreenSize.width * 0.08,
                padding: EdgeInsets.all(6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorGoldButton,
                  // shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Redeem Now',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: fontFamilyMain,
                    color: colorBlackText,
                  ),
                ),
              ),
            ),
          ),
          Divider(thickness: 1, color: colorSocialBoxGrey),
        ],
      ),
    );
  }
}
