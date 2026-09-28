import 'dart:io';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on VoucherPast {
  Widget getVoucherPastTile({
    required BuildContext context,
    required VoidCallback onTap,
    required VoidCallback ontapRate,
    required bool past,
  }) {
    var formatter = DateFormat(appDateFormat);
    var dateExpired = formatter.format(DateTime.parse(expiredAt!));

    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenSize.height * 0.08,
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: CachedImage(
                        imageUrl: image!,
                        colorFilter:
                            isExpired!
                                ? ColorFilter.mode(
                                  colorUsedGray,
                                  BlendMode.color,
                                )
                                : null,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: ScreenSize.height * 0.08,
                    margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
                    decoration: BoxDecoration(
                      color: colorTransparent,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
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
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isExpired!
                    ? Container(
                      height: ScreenSize.height / 13,
                      width: ScreenSize.width * 0.18,
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Expired at',
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
                    )
                    : SizedBox(
                      height: ScreenSize.height / 13,
                      width: ScreenSize.width * 0.18,
                    ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isExpired!
                    ? Container(
                      width: ScreenSize.width * 0.23,
                      height: ScreenSize.width * 0.08,
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color:
                            isExpired!
                                ? colorBlack.withValues(alpha: 0.1)
                                : colorTransparent,
                        // shape: BoxShape.circle,
                        border: Border.all(color: colorGreyBorder),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Expired',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: fontFamilyMain,
                          color: colorBlackText,
                        ),
                      ),
                    )
                    : InkWell(
                      onTap: onTap,
                      child: Container(
                        width: ScreenSize.width * 0.23,
                        height: ScreenSize.width * 0.08,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          // color: colorGoldButton,
                          // shape: BoxShape.circle,
                          border: Border.all(color: colorGreyBorder),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'View',
                          style: TextStyle(
                            fontSize: Platform.isAndroid ? 12 : 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontFamilyMain,
                            color: colorBlackText,
                          ),
                        ),
                      ),
                    ),
                SizedBox(width: ScreenSize.width * 0.02),
                InkWell(
                  onTap:
                      isExpired! || (rating != 0 && comment!.isNotEmpty)
                          ? () {}
                          : ontapRate,
                  child: Container(
                    width: ScreenSize.width * 0.17,
                    height: ScreenSize.width * 0.08,
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isExpired! || (rating != 0 && comment!.isNotEmpty)
                              ? colorGreyExpired
                              : colorMulberry,
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isExpired!
                          ? 'Rate'
                          : (rating != 0 && comment!.isNotEmpty)
                          ? 'Rated'
                          : 'Rate',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamilyMain,
                        color:
                            isExpired! || (rating != 0 && comment!.isNotEmpty)
                                ? colorBlack
                                : colorWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 1, color: colorSocialBoxGrey),
        ],
      ),
    );
  }
}
