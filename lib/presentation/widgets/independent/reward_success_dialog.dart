import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../widgets.dart';

// import 'cache_network_image.dart';

/* Widget class for promotional reward success dialog. Will use in scanner_page.dart and view/voucher_manual.dart.  */

// Content of promotional reward success dialog. Can change design here
class RewardSuccessDialog extends StatelessWidget {
  // final String mainText;
  final Map data;
  final VoidCallback onTap;

  const RewardSuccessDialog({
    super.key,
    // required this.mainText,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: colorBackground,
      alignment: Alignment.center,
      // height: height * 0.4,
      padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Show image icon on top
          Image(
            image: AssetImage('assets/image/ribbon.webp'),
            fit: BoxFit.fill,
          ),
          // Show title
          // Storage().page == 'voucher'
          //     ?
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              // Storage().page == 'voucher' ? 'Congratulations!' : ' Success!',
              'Congratulations!',
              style: TextStyle(
                color: colorMulberry,
                fontFamily: fontFamilyMain,
                fontWeight: FontWeight.w400,
                fontSize: 30,
              ),
            ),
          ),
          // : Container(),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              '${data['message']} \n\n ${data['data']['message']}',
              // Storage().page == 'voucher'
              //     ? '${data['message']} \n\n ${data['data']['message']}'
              //     : '${data['message']}',
              // ?${data['message']}
              // : '${data['message']} \n\n ${data['data']['message']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colorTextGrey,
                fontFamily: fontFamilyMain,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(scaleFactor),
            ),
          ),
          // button to close the dialog
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  // width: width * 0.6,
                  height: ScreenSize.height * 0.07,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 70),
                  decoration: BoxDecoration(
                    color: colorMulberry,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: TextStyle(
                      color: colorWhite,
                      fontSize: 16,
                      fontFamily: fontFamilyMain,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Call this future with text and context. Then will pass to AlertDialog
  static Future showRewardSuccessDialog(
    BuildContext context,
    Map data,
    VoidCallback onTap,
  ) {
    //String text,
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black38,
      barrierLabel: 'Label',
      barrierDismissible: true,
      pageBuilder:
          (_, __, ___) => Center(
            child: Scaffold(
              body: Container(
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                // // color: colorWhite,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     colors: const [
                //       Color(0xFFD4FFDB),
                //       Color(0xFFF0FEF2),
                //       Color(0xFFFFFFFF),
                //     ],
                //     begin: FractionalOffset.topCenter,
                //     end: FractionalOffset.bottomCenter,
                //     // end: Alignment(0.8, 1),
                //     // stops: const [0.0, 0.9],
                //     tileMode: TileMode.clamp,
                //   ),
                // ),
                height: ScreenSize.height,
                width: ScreenSize.width,
                padding: EdgeInsets.fromLTRB(
                  marginHorizontal,
                  ScreenSize.height * 0.1,
                  marginHorizontal,
                  0,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/background_signin.webp'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: RewardSuccessDialog(
                  // mainText: text,
                  data: data,
                  onTap: onTap,
                ),
              ),
            ),
          ),
    );
  }
}
