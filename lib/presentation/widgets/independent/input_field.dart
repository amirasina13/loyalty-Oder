import 'package:flutter/material.dart';

import '../../../app_setting/app_setting.dart';

/* Widget class for custom input field. Standardize the input field  */
class OderInputField extends StatefulWidget {
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
  final String? error;
  final TextCapitalization textCapitalization;
  final Function? onTap;
  final InputBorder? border;
  final bool readOnly;
  final Color? readOnlyColor;
  final TextAlignVertical? textAlignVertical;
  final Icon? suffixIcon;
  final Widget? endIcon;
  final Function? onSaved;
  final TextAlign textAlign;
  final String? errorText;
  final Color? color;

  const OderInputField({
    super.key,
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
    this.horizontalPadding = 15.0,
    this.onValueChanged,
    this.error,
    this.textCapitalization = TextCapitalization.none,
    this.onTap,
    this.border,
    this.readOnly = false,
    this.readOnlyColor,
    this.textAlignVertical,
    this.suffixIcon,
    this.endIcon,
    this.onSaved,
    this.textAlign = TextAlign.start,
    this.errorText,
    this.color = colorBackground,
  });

  @override
  State<StatefulWidget> createState() {
    return OderInputFieldState();
  }
}

class OderInputFieldState extends State<OderInputField> {
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
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 15),
          height:
              widget.maxLines == 1
                  ? MediaQuery.of(context).size.height / 16
                  : MediaQuery.of(context).size.height / 10,
          decoration: BoxDecoration(
            color:
                widget.readOnly == true
                    ? widget.readOnlyColor == null
                        ? Colors.grey[200]
                        : widget.color
                    : widget.color,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: TextFormField(
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
              fontWeight: FontWeight.normal,
              fontSize: 16,
              fontFamily: fontFamilyMain,
            ),
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboard,
            obscureText: _isObscure,
            maxLines: widget.maxLines,
            readOnly: widget.readOnly,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.all(0),
              border: widget.border,
              labelText: widget.label,
              hintText: widget.hint,
              suffixIcon:
                  isChecked
                      ? widget.suffixIcon
                      : widget.isPassword
                      ? IconButton(
                        icon: Icon(
                          _isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color:
                              error != null
                                  ? colorRed
                                  : _isObscure
                                  ? colorDarkGray
                                  : mainColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      )
                      : widget.endIcon,
              hintStyle: TextStyle(
                color: colorDarkGray,
                fontSize: 11,
                fontWeight: FontWeight.w300,
                fontFamily: fontFamilyMain,
              ),
              errorText: widget.errorText,
            ),
            textCapitalization: widget.textCapitalization,
          ),
        ),
      ],
    );
  }

  String? validate() {
    if (widget.validator == null) {
      return null;
    }

    setState(() {
      error = widget.validator!(widget.controller!.text);
    });
    return error;
  }
}
