import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on RewardFavourite {
  Widget getRewardFavouriteListTile({
    required BuildContext context,
    required VoidCallback onTap,
    required VoidCallback onTapFavourite,
    // required bool past,
  }) {
    return InkWell(
      onTap: onTap,
      child: Slidable(
        key: Key(id.toString()),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.2,
          children: [
            InkWell(
              onTap: onTapFavourite,
              child: Container(
                height: ScreenSize.height,
                width: ScreenSize.width * 0.2,
                color: colorBlack.withValues(alpha: 0.1),
                alignment: Alignment.center,
                child: Image(
                  height: ScreenSize.height * 0.023,
                  image: AssetImage('assets/icons/bin.webp'),
                ),
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: ScreenSize.height / 10,
              margin: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: marginHorizontal,
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: CachedImage(
                            imageUrl: image!,
                            // colorFilter: ColorFilter.mode(
                            //   colorUsedGray,
                            //   BlendMode.color,
                            // ),
                          ),
                        ),
                      ),
                      isMuslim == 1
                          ? Positioned(
                            right: 5,
                            top: 5,
                            child: HalalWidget(
                              muslimCategory: muslimCategory!,
                              width: ScreenSize.width * 0.06,
                            ),
                          )
                          : SizedBox(),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
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
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // height: height * 0.03,
                            // padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.topLeft,
                            // color: AppColors.deepYellow,
                            child: Text(
                              name!,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: fontFamilyMain,
                                fontWeight: FontWeight.w500,
                                color: colorBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            // height: height * 0.062,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.topLeft,
                            color: colorTransparent,
                            child: Text(
                              desc!,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: fontFamilyMain,
                                fontWeight: FontWeight.w300,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
