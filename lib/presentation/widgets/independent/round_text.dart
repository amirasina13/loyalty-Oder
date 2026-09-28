import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';

/* Widget class for input field with round border.  */
class OderRoundField extends StatefulWidget {
  // final Widget? iconData;
  final String? error;
  final bool readOnly;
  final BoxBorder? boxBorder;
  final InputBorder? focusBorder;
  final TextStyle? labelStyle;
  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final FormFieldValidator? validator;
  final TextInputType keyboard;
  final int? maxLines;
  final FocusNode? focusNode;
  final VoidCallback? onFinished;
  final bool isPassword;
  final double horizontalPadding;
  final Function? onValueChanged;
  final TextCapitalization textCapitalization;
  final Function? onTap;
  final InputBorder? border;
  final Color? readOnlyColor;
  final TextAlignVertical? textAlignVertical;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? endIcon;
  final Function? onSaved;
  final TextAlign textAlign;
  final bool? canTap;

  const OderRoundField({
    super.key,
    // this.iconData,
    this.error,
    this.readOnly = false,
    this.boxBorder,
    this.focusBorder,
    this.labelStyle,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.validator,
    this.keyboard = TextInputType.text,
    this.maxLines = 1,
    this.focusNode,
    this.onFinished,
    this.isPassword = false,
    this.horizontalPadding = 16.0,
    this.onValueChanged,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.border,
    this.readOnlyColor,
    this.textAlignVertical,
    this.suffixIcon,
    this.prefixIcon,
    this.endIcon,
    this.onSaved,
    this.textAlign = TextAlign.start,
    this.canTap = false,
  });

  @override
  State<StatefulWidget> createState() {
    return OderRoundFieldState();
  }
}

class OderRoundFieldState extends State<OderRoundField> {
  String? error;
  bool isChecked = false;
  late bool _isObscure;

  @override
  void initState() {
    _isObscure = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;

    return TextFormField(
      initialValue: widget.initialValue,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      onChanged: (value) {
        if (widget.onValueChanged != null) {
          widget.onValueChanged!(value);
        }
      },
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!();
        }
      },
      onSaved: (value) {
        if (widget.onSaved != null) {
          widget.onSaved!(value);
        }
      },
      style: TextStyle(
        // height: 1.6,
        color: colorBlack,
        fontWeight: FontWeight.w300,
        fontSize: 16,
        overflow: TextOverflow.ellipsis,
      ),
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: widget.keyboard,
      obscureText: _isObscure,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        filled: widget.readOnly == true ? true : false,
        fillColor:
            widget.readOnly == true && widget.canTap == false
                ? Colors.grey[200]
                : colorBackground,
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: colorUsedGray),
        ),
        focusedBorder: widget.focusBorder,
        labelText: widget.label,
        labelStyle: widget.labelStyle,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
      ),
      textCapitalization: widget.textCapitalization,
    );
  }
}
