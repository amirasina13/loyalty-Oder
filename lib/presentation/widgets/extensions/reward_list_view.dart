import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on VoucherReward {
  Widget getRewardListTile({
    required BuildContext context,
    required VoidCallback onTap,
    required VoidCallback onFavouriteTap,
    required bool isFavClick,
  }) {
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
                  flex: 2,
                  child: Container(
                    height: ScreenSize.height * 0.08,
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
                Flexible(
                  child: Container(
                    height: ScreenSize.height / 14,
                    // width: ScreenSize.width * 0.18,
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          purchaseText!,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: fontFamilyMain,
                            fontWeight: FontWeight.w500,
                            color:
                                !isSoldOut! ? colorRaspberyRed : colorUsedGray,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(height: ScreenSize.height * 0.005),
                        Text(
                          double.parse(faceAmount!) > 0.00
                              ? creditLabelAlign == 'left'
                                  ? '$creditLabelText $faceAmount'
                                  : '$faceAmount $creditLabelText'
                              : '',
                          style: TextStyle(
                            fontSize: 8,
                            fontFamily: fontFamilyMain,
                            fontWeight: FontWeight.w500,
                            color: colorCountGrey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                InkWell(
                  onTap: onFavouriteTap,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colorBackground,
                      shape: BoxShape.circle,
                      border: Border.all(color: colorGreyBorder),
                    ),
                    child:
                        isFavClick
                            ? Container(
                              padding: EdgeInsets.all(2),
                              width: ScreenSize.width * 0.045,
                              height: ScreenSize.width * 0.045,
                              child: CircularProgressIndicator(
                                color: colorSoftGrey.withValues(alpha: 0.5),
                              ),
                            )
                            : isFavourite == false
                            ? Icon(
                              Icons.favorite_border,
                              size: 20,
                              color: colorCountGrey,
                            )
                            : Icon(
                              Icons.favorite,
                              size: 20,
                              color: colorRaspberyRed,
                            ),
                  ),
                ),
                SizedBox(width: ScreenSize.width * 0.02),
                InkWell(
                  onTap: !isSoldOut! ? onTap : () {},
                  child: Container(
                    width: ScreenSize.width * 0.23,
                    height: ScreenSize.width * 0.07,
                    padding: EdgeInsets.all(6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorGoldButton,
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: fontFamilyMain,
                        color: colorBlackText,
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
