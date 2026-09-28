import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../widgets/widgets.dart';
import '../../security_pin/security_pin.dart';
import '../credits.dart';

class PointConversionView extends StatefulWidget {
  final Function? changeView;

  const PointConversionView({super.key, this.changeView});

  @override
  State<PointConversionView> createState() => _PointConversionViewState();
}

class _PointConversionViewState extends State<PointConversionView> {
  FocusNode focusNode = FocusNode();
  FocusNode pinNode = FocusNode();
  String errorfield = '';
  String inputValue = '0';
  double totalConvert = 0;
  double convertRate = 0;
  bool isProcessing = false;
  bool load = false;
  final TextEditingController pinController = TextEditingController();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    margin: EdgeInsets.zero,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();

    // _connectivity.disposeStream();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? colorDarkGray : colorRed,
        ),
      ),
      child: Scaffold(
        backgroundColor: colorBackground,
        body: BlocListener<CreditBloc, CreditState>(
          listener: (context, state) {
            if (state is ConvertSuccess) {
              Navigator.pop(context);
              showSuccessToast(state.message, context);
            }

            if (state is CreditError) {
              setProcessingStatus(false);
              // Navigator.pop(context);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter points',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: fontFamilyMain,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 30.0,
                    ),
                    child: Center(
                      child: TextField(
                        // controller: pointController,
                        decoration: InputDecoration(
                          hintText: '0',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 64.0,
                          fontFamily: fontFamilyMain,
                          fontWeight: FontWeight.w500,
                          color: colorLocationGrey,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        // inputFormatters: [
                        //   DecimalTextInputFormatter(decimalRange: 2)
                        // ],
                        showCursor: false,
                        focusNode: focusNode,
                        enableInteractiveSelection: false,
                        onChanged: (value) {
                          convertRate = 1 / double.parse(pointConvertRate);

                          if (value.isEmpty || value == '') {
                            setState(() {
                              inputValue = '0';
                              totalConvert =
                                  double.parse(inputValue) * convertRate;
                            });
                          } else {
                            setState(() {
                              inputValue = value;
                              totalConvert =
                                  double.parse(inputValue) * convertRate;
                            });
                          }
                        },
                        // onEditingComplete: _submit,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          // height: height / 5,
          margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
          child: BlocListener<SecurityBloc, SecurityState>(
            listener: (context, securityState) {
              if (securityState is SecurityCheckVerified) {
                if (securityState.verified == false) {
                  Storage().page = 'point_convert';

                  Navigator.of(context).pushNamed(OderRoutes.securityCreate);
                } else {
                  Storage().set = 'reset';
                  Storage().page = 'point_convert';

                  Navigator.of(context).pushNamed(OderRoutes.securityChange);
                }
              }

              if (securityState is SecurityPinVerified) {
                _pointConvertAndSend();
              }

              if (securityState is SecurityError) {
                setProcessingStatus(false);
                showErrorToast(securityState.error, context);
              }
            },
            child: OderStyleButton(
              height: ScreenSize.height / 13,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: fontFamilyMain,
              title:
                  isProcessing
                      ? 'Processing...'
                      : '$inputValue points = RM ${totalConvert.toStringAsFixed(2)}', //'$inputValue points = RM ${int.parse(inputValue) * 0.01}',
              backgroundColor: isProcessing ? colorLightGray : mainColor,
              textColor: isProcessing ? colorDarkGray : colorBlack,
              borderRadius: 0,
              onPressed: () {
                if (inputValue == '0') {
                  showErrorToast('Points cannot be 0!', context);
                } else {
                  BlocProvider.of<SecurityBloc>(context).add(SecurityStart());
                }
              }, // _validateAndSend,
            ),
          ),
        ),
      ),
    );
  }

  // Security pin check API
  void _pointConvertAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    BlocProvider.of<CreditBloc>(context).add(
      PointConvertLoad(pin: Storage().securityPin, pointConvert: inputValue),
    );
  }
}
