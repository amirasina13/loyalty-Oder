import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

/* Extension class for outlet list. Will use in extensions/location_screen.dart  */
extension View on RewardOutlet {
  Widget getRewardOutletTile({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    Storage().distance = double.parse(distance!).toStringAsFixed(2);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: colorBackground,
        // height: MediaQuery.of(context).size.height / 12,
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            width: ScreenSize.height * 0.06, //width * 0.09,
            height: ScreenSize.height * 0.06,
            padding: EdgeInsets.all(5),
            child: CachedImage(imageUrl: merchantImg!),
          ),
          title: Text(
            merchantName!,
            style: TextStyle(
              color: colorBlack,
              fontSize: 13,
              fontFamily: fontFamilyMain,
              fontWeight: FontWeight.w300,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          subtitle: Text(
            place!,
            style: TextStyle(
              color: colorBlack,
              fontSize: 13,
              fontFamily: fontFamilyMain,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            textScaler: TextScaler.linear(scaleFactor),
          ),
          trailing: Container(
            width: ScreenSize.width * 0.2,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 8),
            child: Text(
              '${double.parse(distance!).toStringAsFixed(2)} km',
              style: TextStyle(
                fontSize: 13,
                fontFamily: fontFamilyMain,
                fontWeight: FontWeight.w600,
                color: colorBlack,
              ),
              textScaler: TextScaler.linear(scaleFactor),
            ),
          ), //calculateDistance(currentLoc, latitude!, longitude!, width),
        ),
      ),
    );
  }

  // Widget calculateDistance(
  //     LocationData currentLoc, String latitude, String longitude, var width) {
  //   var lat1 = double.parse(currentLoc.latitude.toString());
  //   var lon1 = double.parse(currentLoc.longitude.toString());
  //   var lat2 = double.parse(latitude);
  //   var lon2 = double.parse(longitude);

  //   var p = 0.017453292519943295;
  //   var a = 0.5 -
  //       cos((lat2 - lat1) * p) / 2 +
  //       cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  //   var distance = 12742 * asin(sqrt(a));

  //   return Container(
  //     width: width * 0.2,
  //     alignment: Alignment.centerRight,
  //     padding: EdgeInsets.only(right: 8),
  //     child: Text(
  //       '${distance.toStringAsFixed(2)}km',
  //       style: TextStyle(
  //         fontSize: 13,
  //         fontFamily: fontFamilyMain,
  //         fontWeight: FontWeight.w600,
  //         color: colorBlack,
  //       ),
  //     ),
  //   );
  // }
}
