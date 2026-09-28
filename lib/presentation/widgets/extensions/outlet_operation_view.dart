import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';

import '../../../data/data.dart';

/* Extension class for operation outlet list(will show under outlet details). Will use in features/outlet/view/outlet_details.dart 
& features/rewards/view/outlet_details.dart  */
extension View on Operation {
  Widget getOutletOperationTile({required BuildContext context}) {
    var width = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: width * 0.25,
          margin: EdgeInsets.only(bottom: 3),
          color: colorTransparent,
          padding: EdgeInsets.fromLTRB(0, 0, 9, 0),
          child: Text(
            dayName!,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: colorBlackTab,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
        ),
        Container(
          // width: width * 0.33,
          color: colorTransparent,
          margin: EdgeInsets.symmetric(vertical: 2.8),
          // padding: EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.centerLeft,
          child:
              start == '' && end == ''
                  ? Align(
                    alignment: Alignment.center,
                    child: Text(
                      ' - ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: colorBlackTab,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  )
                  : end == ''
                  ? Text(
                    '$start',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: colorBlackTab,
                    ),
                    textScaler: TextScaler.linear(scaleFactor),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // width: width * 0.15,
                        alignment: Alignment.centerRight,
                        color: colorTransparent,
                        child: Text(
                          '$start',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: colorBlackTab,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      Container(
                        // width: width * 0.02,
                        color: colorTransparent,
                        alignment: Alignment.center,
                        child: Text(
                          ' -  ',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: colorBlackTab,
                          ),
                          textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      Container(
                        // width: width * 0.15,
                        color: colorTransparent,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$end',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: colorBlackTab,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                    ],
                  ),
        ),
      ],
    );
  }
}
