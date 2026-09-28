import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

// Extension class for credit transaction list. Will use in extensions/credit_history_view.dart
extension View on CreditTransaction {
  Widget getCreditTransactionTile({
    required BuildContext context,
    // required VoidCallback onTap,,
  }) {
    var dateFormat = DateFormat(
      appDateFormat,
    ).format(DateTime.parse('$date $time'));
    var timeFormat = DateFormat(
      appTimeFormat,
    ).format(DateTime.parse('$date $time'));

    return Container(
      height: ScreenSize.height / 12,
      color: colorTransparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: ScreenSize.width * 0.08,
                  color: colorBackground,
                  child: Image(
                    image: AssetImage(
                      type == 'debit'
                          ? 'assets/icons/settings/txn-in.webp'
                          : 'assets/icons/settings/txn-out.webp',
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // width: ScreenSize.width * 0.45,
                    // height: ScreenSize.height * 0.06,
                    color: colorTransparent,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: colorTransparent,
                          // height: ScreenSize.height * 0.03,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$method',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: fontFamilyMain,
                              color: colorBlack,
                              fontWeight: FontWeight.bold,
                            ),
                            textScaler: TextScaler.linear(scaleFactor),
                          ),
                        ),
                        Text(
                          '$dateFormat   $timeFormat',
                          // timeformat,
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: fontFamilyMain,
                            color: colorBlack,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: ScreenSize.width * 0.3,
                  color: colorTransparent,
                  child: Text(
                    '${type == 'debit' ? '+' : '-'} ${creditLabelAlign == 'left' ? '$creditLabelText $amount ' : '$amount $creditLabelText '}',
                    textAlign:
                        TextAlign
                            .end, // Ensures multi-line text stays right-aligned
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: fontFamilyMain,
                      color: type == 'debit' ? thirdColor : colorRed,
                      fontWeight: FontWeight.w700,
                    ),
                    textScaler: TextScaler.linear(scaleFactor),
                  ),
                ),
                // Container(
                //   width: ScreenSize.width * 0.35,
                //   height: ScreenSize.height * 0.06,
                //   color: colorTransparent,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.end,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Container(
                //         color: colorTransparent,
                //         height: ScreenSize.height * 0.03,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.end,
                //           // crossAxisAlignment: CrossAxisAlignment.center,
                //           children: [
                //             type == 'debit'
                //                 ? Text(
                //                   '+ ',
                //                   style: TextStyle(
                //                     fontSize: 13,
                //                     color: thirdColor,
                //                     fontFamily: fontFamilyMain,
                //                     fontWeight: FontWeight.w700,
                //                   ),
                //                   textScaler: TextScaler.linear(scaleFactor),
                //                 )
                //                 : Text(
                //                   '- ',
                //                   style: TextStyle(
                //                     fontSize: 13,
                //                     color: colorRed,
                //                     fontFamily: fontFamilyMain,
                //                     fontWeight: FontWeight.w700,
                //                   ),
                //                   textScaler: TextScaler.linear(scaleFactor),
                //                 ),
                //             Text(
                //               creditLabelAlign == 'left'
                //                   ? '$creditLabelText $amount '
                //                   : '$amount $creditLabelText ',
                //               style: TextStyle(
                //                 fontSize: 13,
                //                 fontFamily: fontFamilyMain,
                //                 color: type == 'debit' ? thirdColor : colorRed,
                //                 fontWeight: FontWeight.w700,
                //               ),
                //               textScaler: TextScaler.linear(scaleFactor),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
