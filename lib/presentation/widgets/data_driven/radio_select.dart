import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';

/* Class for radio select. Will use in features/credits/view/credits_online_view.dart & features/transfer_credit/view/transfer_credit_view.dart */
class OderRadioSelect extends StatelessWidget {
  final RadioModel _item;
  const OderRadioSelect(this._item, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _item.isSelected ? colorGoldButton : colorWhite,
        border: Border.all(
          width: 1.0,
          color: _item.isSelected ? colorGoldButton : Color(0xFFECEEF1),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        boxShadow: [
          _item.isSelected
              ? BoxShadow(
                color: colorDisableGrey,
                blurRadius: 5.0,
                offset: Offset(2.0, 2.0),
              )
              : BoxShadow(
                color: colorTransparent,
                blurRadius: 0.0,
                offset: Offset(0.0, 0.0),
              ),
        ],
      ),
      child: Center(
        child: Text(
          _item.buttonText,
          style: TextStyle(
            color: _item.isSelected ? colorMulberry : colorReferGrey,
            fontSize: 13.0,
            fontWeight: FontWeight.w700,
            fontFamily: fontFamilyMain,
          ),
          textScaler: TextScaler.linear(scaleFactor),
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}
