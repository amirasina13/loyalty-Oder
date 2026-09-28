import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../features/ordering/ordering.dart';
import '../../features/voucher/voucher.dart';
import '../../features/webview/webview_deeplink.dart';
import '../widgets.dart';

/* Widget class for bottom menu. Will use mostly in independent/scaffold.dart (custom scaffold) */
class OderBottomMenu extends StatelessWidget {
  final int menuIndex;
  final bool isShow;
  final bool canClick;

  // ignore: use_key_in_widget_constructors
  const OderBottomMenu(this.menuIndex, this.isShow, this.canClick);

  BottomNavigationBarItem getItem(
    BuildContext context,
    String imageSelected,
    String image,
    String title,
    ThemeData theme,
    int index,
    bool isShow,
  ) {
    return BottomNavigationBarItem(
      icon: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: ScreenSize.height * 0.035,
            width: ScreenSize.height * 0.035,
            // margin: EdgeInsets.only(bottom: 2),
            padding: EdgeInsets.only(right: 2, top: 4),
            child: Image(
              image:
                  index == menuIndex && isShow == true
                      ? AssetImage(imageSelected)
                      : AssetImage(image),
              fit: BoxFit.contain,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: fontFamilyMain,
                color:
                    index == menuIndex && isShow == true
                        ? colorRedDark
                        : colorCountGrey,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Pass image icon, title, theme, index no and isShow
    List<BottomNavigationBarItem> menuItems = [
      getItem(
        context,
        imageSelected1,
        imageUnselected1,
        title1,
        theme,
        0,
        isShow,
      ),
      getItem(
        context,
        imageSelected2,
        imageUnselected2,
        title2,
        theme,
        1,
        isShow,
      ),
      getItem(
        context,
        imageSelected3,
        imageUnselected3,
        title3,
        theme,
        2,
        isShow,
      ),
      getItem(
        context,
        imageSelected4,
        imageUnselected4,
        title4,
        theme,
        3,
        isShow,
      ),
      // getItem(
      //     context, imageSelected5, imageUnselected5, title5, theme, 4, isShow),
    ];

    // Custom design for bottom menu
    return Container(
      decoration: BoxDecoration(
        color: colorBackground,
        // border: Border(
        //   top: BorderSide(
        //     color: Color(0xFFC4C4C4),
        //     width: 1.0,
        //   ),
        // ),
        boxShadow: const [
          BoxShadow(color: colorWhite, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorBackground,
        unselectedLabelStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamilyMain,
        ),
        selectedLabelStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w400,
          fontFamily: fontFamilyMain,
        ),
        selectedItemColor:
            isShow == true
                ? colorBlack
                : colorDarkGray.withValues(alpha: 1.0), //colorBlack,
        currentIndex: menuIndex,
        onTap: (value) async {
          TempData.voucherId = '';
          TempData.voucherRefCode = '';
          TempData.affiliateCode = '';
          TempData.currentPage = '';
          if (value != menuIndex) {
            switch (value) {
              case 0:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
                );

                break;
              case 1:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.orderingMerchant,
                  (Route<dynamic> route) => true,
                  arguments: OrderingScreenParameters(selectedTab: 0),
                );

                break;
              case 2:
                Storage().rewardReload = '';
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.voucher,
                  (Route<dynamic> route) => true,
                  arguments: VoucherParameters(
                    selectedTab: 0,
                    filterBy: 'all',
                    filterValue: '1',
                  ),
                );

                break;
              case 3:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.wallet,
                  (Route<dynamic> route) => true,
                );

                break;
              // case 4:
              //   // BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
              //   Navigator.of(context).pushNamedAndRemoveUntil(
              //     OderRoutes.setting,
              //     (Route<dynamic> route) => true,
              //   );

              //   break;
            }
          } else if (value == menuIndex && canClick == true) {
            switch (value) {
              case 0:
                // await Storage().secureStorage.delete(key: 'vId');
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
                );

                break;
              case 1:
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   OderRoutes.orderingMerchant,
                //   (Route<dynamic> route) => true,
                //   arguments: OrderingScreenParameters(selectedTab: 0),
                // );
                break;
              case 2:
                Storage().rewardReload = '';
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   OderRoutes.voucher,
                //   (Route<dynamic> route) => true,
                //   arguments: VoucherParameters(
                //     selectedTab: 0,
                //     filterBy: 'all',
                //     filterValue: '1',
                //   ),
                // );

                break;
              case 3:
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.wallet,
                  (Route<dynamic> route) => true,
                );
                break;
            }
          }
        },
        items: menuItems,
      ),
    );
  }
}
