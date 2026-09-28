import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../widgets/widgets.dart';
import '../security_pin.dart';

class PasscodeView extends StatefulWidget {
  final Function changeView;
  const PasscodeView({super.key, required this.changeView});

  @override
  State<PasscodeView> createState() => _PasscodeViewState();
}

class _PasscodeViewState extends State<PasscodeView> {
  bool isProcessing = false, isResetProcessing = false;
  String enteredPin = '';
  String verifyPin = '';

  /// this widget will be use for each digit
  Widget numButton(int number) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3),
        margin: EdgeInsets.symmetric(horizontal: 3),
        child: TextButton(
          onPressed: () {
            setState(() {
              if (enteredPin.length < 6) {
                enteredPin += number.toString();

                verifyPin = enteredPin;
              }
            });

            if (verifyPin.length == 6) {
              _validateAndSend();
            }
          },
          style: TextButton.styleFrom(backgroundColor: colorWhite),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: colorBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  void setResetProcessingStatus(bool processing) {
    setState(() {
      isResetProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<SecurityBloc, SecurityState>(
        listener: (context, state) {
          if (state is SecurityPinVerified) {
            setProcessingStatus(false);
            Storage().secureStorage.delete(key: 'voucherRefCode');
            Navigator.pop(context, verifyPin);

            // Future.delayed(Duration.zero, () {
            //   Navigator.pop(context, verifyPin);
            // });
          }

          if (state is SecurityOtpSent) {
            setResetProcessingStatus(false);
            showSuccessToast(state.data['message'], context);
            Navigator.of(context).pushNamed(
              OderRoutes.securityOtp,
              arguments: SecurityOtpParameters(otpData: state.data),
            );
          }

          if (state is SecurityError) {
            setProcessingStatus(false);
            setResetProcessingStatus(false);
            enteredPin = '';
            showErrorToast(state.error, context);
          }
        },
        builder: (context, state) {
          // if (state is SecurityProcessing) {
          //   return LoadingWidget();
          // }
          return Scaffold(
            backgroundColor: colorWhite,
            body:
                state is SecurityProcessing
                    ? LoadingWidget()
                    : SingleChildScrollView(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(
                              marginHorizontal,
                              50,
                              marginHorizontal,
                              0,
                            ),
                            // padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                            height: ScreenSize.height / 7,
                            child: Text(
                              'Passcode',
                              style: TextStyle(
                                fontFamily: fontFamilyMain,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              bottom: 10,
                              top: ScreenSize.height / 8,
                            ),
                            padding: EdgeInsets.fromLTRB(
                              marginHorizontal,
                              20,
                              marginHorizontal,
                              0,
                            ),
                            child: Text(
                              'Enter Passcode',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colorBlack,
                                fontFamily: fontFamilyMain,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              marginHorizontal,
                              20,
                              marginHorizontal,
                              0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(6, (index) {
                                return Container(
                                  // padding: EdgeInsets.all(15),
                                  margin: const EdgeInsets.all(10.0),
                                  // width: isPinVisible ? 50 : 16,
                                  // height: isPinVisible ? 50 : 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          index < enteredPin.length
                                              ? colorRedDark
                                              : colorGreyBox,
                                      width: 2,
                                    ),
                                    // borderRadius: BorderRadius.circular(6.0),
                                    // color: index < enteredPin.length ? colorBlack : colorWhite,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(13),
                                    // margin: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // border: Border.all(color: colorGreyBox),
                                      // borderRadius: BorderRadius.circular(6.0),
                                      color:
                                          index < enteredPin.length
                                              ? colorGoldButton
                                              : colorWhite,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Container(
                            // padding: EdgeInsets.only(top: 10),
                            margin: EdgeInsets.only(
                              top: ScreenSize.height * 0.15,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Forgot Passcode?',
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                OderButtonText(
                                  'Reset',
                                  color:
                                      isResetProcessing
                                          ? processing
                                          : colorBlack,
                                  fontSize: 13.0,
                                  underline: true,
                                  fontWeight: FontWeight.w600,
                                  // fontStyle: FontStyle.italic,
                                  onClick: () {
                                    setResetProcessingStatus(true);

                                    BlocProvider.of<SecurityBloc>(
                                      context,
                                    ).add(SecurityOtpSend());
                                  },
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.fromLTRB(
                          //     marginHorizontal,
                          //     10,
                          //     marginHorizontal,
                          //     0,
                          //   ),
                          //   margin: EdgeInsets.only(bottom: 20),
                          //   child: Column(
                          //     children: [
                          //       OderStyleButton(
                          //         title: 'Continue',
                          //         // iconLeading: false,
                          //         // icon: Icons.arrow_forward,
                          //         onPressed: () {
                          //           _validateAndSend();
                          //           // widget.changeView(changeType: ViewChangeType.Forward);
                          //         },
                          //         backgroundColor: colorMulberry,
                          //       ),
                          //       InkWell(
                          //         onTap: () {
                          //           Navigator.pop(context);
                          //           FocusScope.of(context).unfocus();
                          //         },
                          //         child: Container(
                          //           margin: EdgeInsets.only(bottom: 5, top: 10),
                          //           child: Text(
                          //             'Cancel',
                          //             style: TextStyle(
                          //               fontSize: 12,
                          //               fontWeight: FontWeight.w700,
                          //               fontFamily: fontFamilyMain,
                          //               color: colorBlack,
                          //               decoration: TextDecoration.underline,
                          //             ),
                          //             textScaler: TextScaler.linear(scaleFactor),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      // ),
                    ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    color: colorGreyBox,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          List.generate(
                            3,
                            (index) => numButton(1 + 3 * i + index),
                          ).toList(),
                    ),
                  ),

                /// 0 digit with back remove
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: colorGreyBox,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // TextButton(onPressed: null, child: SizedBox()),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          margin: EdgeInsets.symmetric(horizontal: 3),
                        ),
                      ),
                      numButton(0),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (enteredPin.isNotEmpty) {
                                  enteredPin = enteredPin.substring(
                                    0,
                                    enteredPin.length - 1,
                                  );
                                }
                              });
                            },
                            // style: TextButton.styleFrom(
                            //   backgroundColor: colorWhite,
                            // ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.backspace,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (enteredPin.isEmpty) {
      setProcessingStatus(false);
      showErrorToast('Passcode are required!', context);
    } else if (enteredPin.length < 6) {
      setProcessingStatus(false);
      showErrorToast('Passcode must be 6 digit', context);
    } else {
      // setProcessingStatus(true);
      // Storage().securityPin = enteredPin;
      BlocProvider.of<SecurityBloc>(
        context,
      ).add(SecurityPinVerify(pin: enteredPin));
    }
  }
}
