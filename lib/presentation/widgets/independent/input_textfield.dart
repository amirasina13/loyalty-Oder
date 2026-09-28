import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';

class OderAppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function()? onEditingComplete;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Color? bottomBorderColor;
  final EdgeInsetsGeometry? contentPadding;
  final bool isPassword;
  final Widget? endIcon;
  final TextAlignVertical? textAlignVertical;
  final bool readOnly;
  final Color? readOnlyColor;
  final TextCapitalization textCapitalization;

  const OderAppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.maxLines = 1,
    this.minLines,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.bottomBorderColor = colorWhite,
    this.contentPadding,
    this.isPassword = false,
    this.endIcon,
    this.textAlignVertical,
    this.readOnly = false,
    this.readOnlyColor,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<OderAppTextField> createState() => _OderAppTextFieldState();
}

class _OderAppTextFieldState extends State<OderAppTextField> {
  String? error;
  bool isChecked = false;
  late bool isObscure;

  @override
  void initState() {
    isObscure = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textAlignVertical: widget.textAlignVertical,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            isChecked
                ? widget.suffixIcon
                : widget.isPassword
                ? IconButton(
                  icon: Icon(
                    isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: error != null ? colorRed : colorTextGrey,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                )
                : widget.endIcon,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.bottomBorderColor!),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.bottomBorderColor!),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: widget.bottomBorderColor!),
        ),
        hintStyle: widget.hintStyle,
        labelStyle: widget.labelStyle,
        contentPadding: widget.contentPadding,
      ),
      keyboardType: widget.keyboardType,
      obscureText: isObscure,
      validator: widget.validator,
      onChanged: widget.onChanged,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onEditingComplete: widget.onEditingComplete,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      style: widget.style,
      textCapitalization: widget.textCapitalization,
    );
  }
}
