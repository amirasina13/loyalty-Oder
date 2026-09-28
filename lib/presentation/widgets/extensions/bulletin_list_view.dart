import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../widgets.dart';

// Extension class for bulletin list. Will use in features/bulletin/view/bulletin_view.dart
extension View on Bulletin {
  Widget getBulletinTile({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        highlightColor: colorWhiteGrey,
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Container(
            decoration: BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 5.0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedImage(imageUrl: image!),
            ),
          ),
        ),
      ),
    );
  }
}
