import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';

/* Class for toast dialog.  */

late FToast fToast;

void showSuccess(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.blueAccent,
    textColor: colorWhite,
    fontSize: 16.0,
  );
}

void cancelToast() {
  Fluttertoast.cancel();
}

// void showCustomToast(String msg) {
//   Widget toast = Container(
//     margin: const EdgeInsets.only(bottom: 85),
//     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(25.0),
//       color: colorDeepBlue,
//     ),
//     child: Text(
//       msg,
//       style: TextStyle(
//         color: colorWhite,
//         fontSize: 14,
//         fontFamily: fontFamilyMain,
//       ),
//       textScaler: TextScaler.linear(scaleFactor),
//     ),
//   );

//   fToast.showToast(child: toast, toastDuration: Duration(seconds: 2));
// }

void showErrorToast(String msg, BuildContext context) {
  var regExp = RegExp(r"\w+(\'\w+)?");
  int wordscount = regExp.allMatches(msg).length;

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: colorRed,
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: colorWhite),
          child: Icon(Icons.close, color: colorRed, size: 20),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(
              msg,
              style: TextStyle(
                color: colorWhite,
                fontSize: 14,
                fontFamily: fontFamilyMain,
              ),
              maxLines: 4,
              textScaler: TextScaler.linear(scaleFactor),
            ),
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: Duration(
      seconds:
          wordscount <= 10
              ? 3
              : wordscount <= 15
              ? 4
              : wordscount <= 17
              ? 5
              : 6,
    ),
    // gravity: ToastGravity.TOP,
    positionedToastBuilder: (context, child, gravity) {
      return Positioned(
        top: 67.0,
        left: marginHorizontal,
        right: marginHorizontal,
        child: child,
      );
    },
  );
}

void showSuccessToast(String msg, BuildContext context) {
  Widget toast = Container(
    // margin: const EdgeInsets.only(top: 20),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xFF04CA53),
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: colorWhite),
          child: Icon(Icons.check, color: Color(0xFF04CA53), size: 20),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(
              msg,
              style: TextStyle(
                color: colorWhite,
                fontSize: 14,
                fontFamily: fontFamilyMain,
              ),
              maxLines: 4,
              textScaler: TextScaler.linear(scaleFactor),
            ),
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: Duration(seconds: 3),
    positionedToastBuilder: (context, child, gravity) {
      return Positioned(
        top: 67.0,
        left: marginHorizontal,
        right: marginHorizontal,
        child: child,
      );
    },
  );
}

void showPaginationToast(String msg, BuildContext context) {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: mainColor,
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(
              msg,
              style: TextStyle(
                color: colorWhite,
                fontSize: 14,
                fontFamily: fontFamilyMain,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              textScaler: TextScaler.linear(scaleFactor),
            ),
          ),
        ),
      ],
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: Duration(seconds: 2),
    // gravity: ToastGravity.TOP,
    positionedToastBuilder: (context, child, gravity) {
      return Positioned(
        bottom: 67.0,
        left: marginHorizontal,
        right: marginHorizontal,
        child: child,
      );
    },
  );
}

void showErrorScannerToast(String msg, BuildContext context) {
  final scannerToast = FToast()..init(context);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: colorRed,
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: colorWhite),
          child: Icon(Icons.close, color: colorRed, size: 20),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 8),
            child: Text(
              msg,
              style: TextStyle(
                color: colorWhite,
                fontSize: 14,
                fontFamily: fontFamilyMain,
              ),
              maxLines: 4,
              textScaler: TextScaler.linear(scaleFactor),
            ),
          ),
        ),
      ],
    ),
  );

  scannerToast.showToast(
    child: toast,
    toastDuration: Duration(seconds: 6),
    // gravity: ToastGravity.TOP,
    positionedToastBuilder: (context, child, gravity) {
      return Positioned(
        top: 67.0,
        left: marginHorizontal,
        right: marginHorizontal,
        child: child,
      );
    },
  );
}
