import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';
/* Class for dropdown value. Will use in features/delete_account/view/delete_view.dart, features/forgot_pass/view/forgot_view.dart, 
features/login/login_screen.dart, features/register/profile_view.dart, features/settings/view/profile_view.dart */

class OderSelectValue<T> extends StatefulWidget {
  final List<T> availableValues;
  final T selectedValue;
  final String? hint;
  // final double horizontalPadding;
  final Function(T) onClick;
  final String? error;
  final double width;
  final InputBorder? border;
  final Color? dropdownColor;
  final Color? color;

  const OderSelectValue({
    super.key,
    required this.availableValues,
    required this.selectedValue,
    this.hint,
    // this.horizontalPadding = 16.0,
    required this.onClick,
    this.error,
    required this.width,
    this.border,
    this.dropdownColor = colorBlack,
    this.color = colorWhite,
  });

  @override
  OderSelectValueState<T> createState() => OderSelectValueState<T>();
}

class OderSelectValueState<T> extends State<OderSelectValue<T>> {
  late T selectedValue;
  String? error;
  bool isChecked = false;

  @override
  void initState() {
    selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    error = widget.error;

    return Column(
      children: <Widget>[
        Container(
          color: colorTransparent,
          height: MediaQuery.of(context).size.height / 14,
          width: widget.width,
          child: Container(
            color: widget.color,
            child: Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: _buildDropDown(context),
            ),
          ),
        ),
        error == null
            ? Container()
            : Text(
              error!,
              style: TextStyle(
                color: colorDeepSkyBlue,
                fontSize: 12,
                fontFamily: fontFamilyMain,
              ),
              textScaler: TextScaler.linear(scaleFactor),
            ),
      ],
    );
  }

  DropdownButtonHideUnderline _buildDropDown(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;

    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        child: DropdownButton(
          isDense: true,
          iconSize: 20,
          dropdownColor: widget.dropdownColor,
          iconEnabledColor: colorDarkGray,
          items:
              widget.availableValues.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: SizedBox(
                    width: widget.width - 20, // width * 0.08,
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        color: colorBlack,
                        fontSize: 14,
                        fontFamily: fontFamilyMain,
                        // fontWeight: FontWeight.w300,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ),
                );
              }).toList(),
          isExpanded: false,
          value: selectedValue,
          onChanged: (dynamic newValue) {
            _updateSelectedValue(newValue);
          },
          hint: Text(widget.hint!, textScaler: TextScaler.linear(scaleFactor)),
          style: TextStyle(
            color: colorDarkGray,
            fontSize: 16,
            fontFamily: fontFamilyMain,
          ),
        ),
      ),
    );
  }

  void _updateSelectedValue(T newValue) {
    selectedValue = newValue;
    setState(() {});
    widget.onClick(selectedValue);
  }
}
