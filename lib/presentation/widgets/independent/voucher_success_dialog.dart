import 'package:barcode_widget/barcode_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../app_setting/app_setting.dart';
import '../widgets.dart';

/* Widget class for promotional reward success dialog. Will use in scanner_page.dart and view/voucher_manual.dart.  */

// Content of promotional reward success dialog. Can change design here
class VoucherSuccessDialog extends StatelessWidget {
  // final String mainText;
  final Map data;
  final VoidCallback onTap;

  const VoucherSuccessDialog({
    super.key,
    // required this.mainText,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var qrSize = ScreenSize.width * 0.7;
    var paddingBox = EdgeInsets.all(20);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: colorBackground,
            alignment: Alignment.center,
            height: ScreenSize.height,
            padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
            child: ListView(
              // mainAxisSize: MainAxisSize.min,
              // crossAxisAlignment: CrossAxisAlignment.center,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                // Show image icon on top
                Container(
                  height: ScreenSize.width * 0.3,
                  // color: colorYellowCard,
                  margin: EdgeInsets.only(top: 30, bottom: 10),
                  child: Image(
                    image: AssetImage('assets/image/redeem_success.webp'),
                    // fit: BoxFit.fill,
                  ),
                ),
                // Show title
                // Storage().page == 'voucher'
                //     ?
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: Text(
                    'Redeemed!',
                    style: TextStyle(
                      color: thirdColor,
                      fontFamily: fontFamilyMain,
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                    ),
                  ),
                ),
                Divider(color: colorTextGrey),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date & Time',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: fontFamilyMain,
                          fontWeight: FontWeight.w500,
                          color: colorRedeemGrey,
                        ),
                      ),
                      Text(
                        data['data']['voucher']['redeemAt'],
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: fontFamilyMain,
                          fontWeight: FontWeight.w500,
                          color: colorBlackTab,
                        ),
                      ),
                    ],
                  ),
                ),
                scanning == 'qr'
                    ? Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: paddingBox,
                      decoration: BoxDecoration(
                        color: colorWhiteQrLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: qrSize,
                            width: qrSize,
                            // width: width,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: PrettyQrView.data(
                                data: data['data']['voucher']['codeString'],
                                decoration: const PrettyQrDecoration(
                                  image: PrettyQrDecorationImage(
                                    image: AssetImage(
                                      'assets/logo/order_splash_logo.png',
                                    ),
                                  ),
                                  quietZone: PrettyQrQuietZone.zero,
                                ),
                                errorCorrectLevel: QrErrorCorrectLevel.Q,
                              ),
                            ),
                            // child: Image(
                            //   image:
                            //       Image.memory(
                            //         base64.decode(
                            //           data['data']['voucher']['qr'].replaceAll(
                            //             RegExp(r'^data:image\/[a-z]+;base64,'),
                            //             '',
                            //           ),
                            //         ),
                            //       ).image,
                            //   fit: BoxFit.contain,
                            // ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              'This coupon code is for single use only.',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: fontFamilyMain,
                                fontWeight: FontWeight.w500,
                                color: colorRedeemGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: paddingBox,
                      decoration: BoxDecoration(
                        color: colorWhiteQrLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            // height: qrSize,
                            // width: qrSize,
                            width: ScreenSize.width,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: colorWhite,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: BarcodeWidget(
                                barcode: Barcode.code128(),
                                data: data['data']['voucher']['codeString'],
                                padding: EdgeInsets.all(30),
                                // drawText: false,
                                textPadding: 15,
                              ),
                            ),
                            // child: Image(
                            //   // height: height / 3,
                            //   // width: height / 3,
                            //   image:
                            //       Image.memory(
                            //         base64.decode(
                            //           data['data']['voucher']['barcode']!
                            //               .replaceAll(
                            //                 RegExp(
                            //                   r'^data:image\/[a-z]+;base64,',
                            //                 ),
                            //                 '',
                            //               ),
                            //         ),
                            //       ).image,
                            //   //  base64String = barcode!
                            //   //     .replaceAll(RegExp(r'^data:image\/[a-z]+;base64,'), '');
                            //   // imageBarcode = Image.memory(base64.decode(base64String));
                            //   fit: BoxFit.contain,
                            // ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Text(
                              'This coupon code is for single use only.',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: fontFamilyMain,
                                fontWeight: FontWeight.w500,
                                color: colorRedeemGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 2, right: 2),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(5),
                    dashPattern: const [8, 8],
                    color: colorBlack,
                    strokeWidth: 2,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      alignment: Alignment.center,
                      child: Text(
                        data['data']['voucher']['code'],
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: fontFamilyMain,
                          fontWeight: FontWeight.w600,
                          color: colorBlackTab,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 60),
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      // width: width * 0.6,
                      height: ScreenSize.height * 0.06,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                        color: colorMulberry,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        'Done',
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

                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Call this future with text and context. Then will pass to AlertDialog
  static Future showVoucherSuccessDialog(
    BuildContext context,
    Map data,
    VoidCallback onTap,
  ) {
    //String text,
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black38,
      barrierLabel: 'Label',
      barrierDismissible: false,
      pageBuilder:
          (_, __, ___) => PopScope(
            canPop: false,
            child: VoucherSuccessDialog(
              // mainText: text,
              data: data,
              onTap: onTap,
            ),
          ),
    );
  }
}
