import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on MerchantBookmark {
  Widget getMerchantBookmarkListTile({
    required BuildContext context,
    required VoidCallback onTap,
    required VoidCallback onTapBookmark,
    // required SlidableController controllerSlider,
    // required bool past,
  }) {
    // return Builder(
    //   builder: (context) {
    return InkWell(
      onTap: onTap,
      child: Slidable(
        key: Key(id.toString()),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.2,
          // dismissible: DismissiblePane(onDismissed: () {}),
          // A pane can dismiss the Slidable.
          // All actions are defined in the children parameter.
          children: [
            // SlidableAction(
            //   onPressed: (_) => onTapBookmark,
            //   backgroundColor: colorBlack.withOpacity(0.1),
            //   foregroundColor: mainColor,
            //   // icon: Icons.save,
            //   label: 'Unfollow',
            // ),
            InkWell(
              onTap: onTapBookmark,
              child: Container(
                height: ScreenSize.height,
                width: ScreenSize.width * 0.2,
                color: colorBlack.withValues(alpha: 0.1),
                alignment: Alignment.center,
                child: Text(
                  'Unfollow',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (contextFromLayoutBuilder, constraints) {
            return Container(
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
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: colorBabyBlue,
                            border: Border.all(color: colorPinGrey),
                          ),
                          // )
                          child: ClipOval(
                            child: CachedImage(
                              imageUrl: image!,
                              // colorFilter: ColorFilter.mode(
                              //   colorUsedGray,
                              //   BlendMode.color,
                              // ),
                            ),
                          ),
                        ),
                      ),
                      isMuslim == 1
                          ? Positioned(
                            top: ScreenSize.height * 0.02,
                            right: ScreenSize.width * 0.05,
                            child: HalalWidget(
                              muslimCategory: muslimCategory!,
                              isCircle: true,
                              width: ScreenSize.width * 0.04,
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
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                color: colorBlack,
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
                                fontFamily: 'Inter',
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
