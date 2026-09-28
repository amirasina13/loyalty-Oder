import 'dart:async';

import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../widgets/widgets.dart';
import '../../maintenance/maintenance_screen.dart';
import '../security_pin.dart';

class SecurityOtpView extends StatefulWidget {
  final Function changeView;
  final Map otpData;

  const SecurityOtpView({
    super.key,
    required this.changeView,
    required this.otpData,
  });

  @override
  State<SecurityOtpView> createState() => _SecurityOtpViewState();
}

class _SecurityOtpViewState extends State<SecurityOtpView> {
  bool error = false;
  bool isProcessing = false;
  int secondsRemaining = 60;
  bool enableResend = true;
  String errorfield = '';
  String reqEmail = '', resendvToken = '', tokenVerify = '';

  /// Create Controller
  // final otpController = TextEditingController();
  // OtpFieldController otpController = OtpFieldController();
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  String? otpCode = '';
  late double sizeBetween;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeBetween = ScreenSize.height / 20;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: error == false ? colorBlack : colorRed,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: colorWhite,
          body: BlocConsumer<SecurityBloc, SecurityState>(
            listener: (context, state) {
              // on success delete navigator stack and push to home
              if (state is SecurityOtpVerified) {
                setProcessingStatus(false);

                showSuccessToast(state.data['message'], context);
                Navigator.of(context).pushNamed(OderRoutes.securitySet);
              }
              if (state is SecurityOtpSent) {
                setProcessingStatus(false);
                showSuccessToast(state.data['message'], context);

                resendvToken = state.data['data']['vToken'];
                tokenVerify = state.data['data']['otp_token'];
              }
              // on failure show a snackbar
              if (state is SecurityError) {
                // ignore: unnecessary_null_comparison
                state.error != null ? error = true : error = false;
                setProcessingStatus(false);
                // pinController.clear();
                showErrorToast(state.error, context);
                // ErrorIconDialog.showErrorDialog(context, state.error);
              }
              /* --------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
              if (state is SecurityMaintenanceError) {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (BuildContext context) => MaintenanceScreen(
                          parameters: MaintenanceParameters(
                            message: state.message,
                          ),
                        ),
                  ),
                  ModalRoute.withName('/'),
                );
              }
            },
            builder: (context, state) {
              // show loading screen while processing
              if (state is SecurityProcessing) {
                // return Center(
                //   child: CircularProgressIndicator(color: colorDisableGrey,),
                // );
              }

              if (state is SecurityInitial) {
                reqEmail = widget.otpData['data']['send_to'];
                resendvToken = widget.otpData['data']['vToken'];
                tokenVerify = widget.otpData['data']['otp_token'];
              }

              return Container(
                height: ScreenSize.height - (ScreenSize.height * 0.12),
                color: colorBackground,
                margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            // alignment: Alignment.center,
                            // margin: EdgeInsets.only(top: 50),
                            padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                            // height: height / 7,
                            child: Text(
                              'Enter the OTP Code sent to',
                              style: TextStyle(
                                fontFamily: fontFamilyMain,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            // alignment: Alignment.center,
                            // margin: EdgeInsets.only(top: 50),
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            // height: height / 7,
                            child: Text(
                              reqEmail,
                              style: TextStyle(
                                fontFamily: fontFamilyMain,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: sizeBetween * 2),
                          Container(
                            color: colorTransparent,
                            height: ScreenSize.height / 15,
                            child: Pinput(
                              length: 6,
                              controller: pinController,
                              autofocus: true,
                              focusNode: focusNode,
                              defaultPinTheme: PinTheme(
                                width: 56,
                                height: 56,
                                textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        error == false
                                            ? colorSocialBoxGrey
                                            : colorRed,
                                  ),
                                ),
                              ),
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              hapticFeedbackType:
                                  HapticFeedbackType.lightImpact,
                              onCompleted: (pin) {
                                otpCode = pin;
                              },
                              onChanged: (value) {
                                setState(() {
                                  error = false;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: sizeBetween * 0.8),
                          OderStyleButton(
                            height: ScreenSize.height / 14,
                            title: 'Continue',
                            iconLeading: false,
                            icon: Icons.arrow_forward,
                            backgroundColor:
                                isProcessing ? processing : colorBlackTab,
                            textColor:
                                isProcessing ? processingText : colorWhite,
                            onPressed: isProcessing ? () {} : _validateAndSend,
                          ),
                          Container(
                            // height: height * 0.05,
                            // width: width,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: 15, top: 70),
                            color: colorTransparent,
                            child:
                                enableResend == false
                                    ? Countdown(
                                      seconds: 60,
                                      build: (_, double time) {
                                        var duration = Duration(
                                          seconds: time.toInt(),
                                        );
                                        return Container(
                                          alignment: Alignment.center,
                                          // padding:
                                          //     EdgeInsets.only(left: 16.0, top: 0.0),
                                          child: Text(
                                            // 'Remaining Time: ${duration.inMinutes}:${duration.inSeconds.remainder(60)}',
                                            // '${duration.inSeconds} seconds  ',
                                            '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                            style: TextStyle(
                                              color: colorCountGrey,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: fontFamilyMain,
                                            ),
                                            textScaler: TextScaler.linear(
                                              scaleFactor,
                                            ),
                                          ),
                                        );
                                      },
                                      onFinished: () {},
                                    )
                                    : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Container(
                        height: ScreenSize.height / 5,
                        margin: EdgeInsets.symmetric(
                          horizontal: marginHorizontal,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Didn\'t receive it?',
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  OderButtonText(
                                    'Send again',
                                    color:
                                        enableResend == true
                                            ? colorBlack
                                            : colorDarkGray,
                                    fontSize: 13.0,
                                    underline: true,
                                    fontWeight: FontWeight.w600,
                                    // fontStyle: FontStyle.italic,
                                    onClick:
                                        enableResend == true
                                            ? _resendOtp
                                            : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _resendOtp() {
    enableResend = false;
    BlocProvider.of<SecurityBloc>(context).add(SecurityOtpResend());

    Timer(Duration(seconds: 60), () {
      if (!mounted) return;
      setState(() {
        enableResend = true;
      });
    });
  }

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    // Navigator.of(context).pushNamed( OderRoutes.securitySet);

    if (otpCode == '') {
      setProcessingStatus(false);
      errorfield = 'errorOtp';
      showErrorToast('OTP number are required!', context);

      // ErrorIconDialog.showErrorDialog(context, 'OTP number are required!');
    } else {
      errorfield == '';
      setProcessingStatus(true);
      // Storage().otp = otpController.text;
      // Navigator.of(context).pushNamed( OderRoutes.securitySet);
      BlocProvider.of<SecurityBloc>(
        context,
      ).add(SecurityOtpVerify(otp: otpCode!, otpToken: tokenVerify));
    }
  }
}
