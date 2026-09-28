import 'dart:async';

import 'package:pinput/pinput.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../app_setting/app_setting.dart';
import '../../widgets/widgets.dart';
import 'otp.dart';

class OtpVerifyParameters {
  final Map data;

  const OtpVerifyParameters({required this.data});
}

class OtpVerifyScreen extends StatefulWidget {
  final OtpVerifyParameters parameters;

  const OtpVerifyScreen({super.key, required this.parameters});

  @override
  State<StatefulWidget> createState() {
    return _OtpVerifyScreenState();
  }
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  // OtpFieldController otpController = OtpFieldController();

  String otpCode = '', resendvToken = '', tokenVerify = '';
  late double sizeBetween;
  int secondsRemaining = 60;
  bool error = false;
  bool enableResend = true;
  bool isProcessing = false, isRegisterEmail = false;
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    resendvToken = widget.parameters.data['data']['vToken'];
    tokenVerify = widget.parameters.data['data']['token'];

    isRegisterEmail = registerMethod == 'email';
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
          cursorColor: error == false ? colorDarkGray : colorRed,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          // backgroundColor: colorWhite,
          body: BlocConsumer<OtpBloc, OtpState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              // on success delete navigator stack and push to home
              if (state is OtpFinished) {
                RegisterTimerDialog.showSuccessDialog(context);
              }
              if (state is OtpResent) {
                setProcessingStatus(false);
                resendvToken = state.data['data']['vToken'];
                tokenVerify = state.data['data']['token'];
                showSuccessToast(state.data['message'], context);
              }
              if (state is OtpError) {
                // ignore: unnecessary_null_comparison
                state.error != null ? error = true : error = false;
                setProcessingStatus(false);
                // otpController.clear();
                showErrorToast(state.error, context);
              }
            },
            builder: (context, state) {
              // show loading screen while processing
              if (state is OtpProcessing) {
                // return Center(
                //   child: CircularProgressIndicator(color: colorDisableGrey,),
                // );
              }

              return SingleChildScrollView(
                child: Container(
                  height: ScreenSize.height,
                  width: ScreenSize.width,
                  padding: EdgeInsets.fromLTRB(
                    marginHorizontal,
                    ScreenSize.height * 0.05,
                    marginHorizontal,
                    0,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/background_signin.webp'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: colorMulberry),
                        iconSize: ScreenSize.height * 0.03,
                        onPressed: _showLogInScreen,
                      ),
                      Center(
                        child: Image(
                          image: AssetImage(mainLogo),
                          height: ScreenSize.height * 0.13,
                        ),
                      ),
                      SizedBox(height: ScreenSize.height * 0.02),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'OTP VERIFICATION',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontFamilyMain,
                            color: colorBlackText,
                          ),
                        ),
                      ),
                      SizedBox(height: sizeBetween * 0.5),
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
                              color: colorWhite,
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
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (pin) {
                            otpCode = pin;
                            _verifyOtp();
                          },
                          onChanged: (value) {
                            setState(() {
                              error = false;
                            });
                          },
                        ),
                      ),
                      Container(
                        height: ScreenSize.height / 6,
                        width: ScreenSize.width,
                        margin: EdgeInsets.symmetric(vertical: 30),
                        decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0.0, 5.0),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(15),
                        child: RichText(
                          text: TextSpan(
                            // Note: Styles for TextSpans must be explicitly defined.
                            // Child text spans will inherit styles from parent
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: colorBlack,
                              fontFamily: fontFamilyMain,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    'Note: \n1. A verification code has been sent to ',
                              ),
                              TextSpan(
                                text: widget.parameters.data['data']['send_to'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text:
                                    ' through email. \n\n2. If you did not receive the code, please check the spam filter or click on ',
                              ),
                              TextSpan(
                                text: 'Resend OTP ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: 'below.'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: sizeBetween * 0.4),
                      Container(
                        height: ScreenSize.height * 0.09,
                        width: ScreenSize.width,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 5, bottom: 15),
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
                                        '${duration.inSeconds} seconds left before enabling resend',
                                        style: TextStyle(
                                          color: mainColor,
                                          fontSize: 14,
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
                                : OderButtonText(
                                  'Resend OTP',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      enableResend == true
                                          ? colorLightBlue
                                          : colorDarkGray,
                                  onClick:
                                      enableResend == true ? _resendOtp : null,
                                ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLogInScreen() {
    // Storage().dynamicLink = null;
    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.login,
      (Route<dynamic> route) => false,
    );
  }

  void _resendOtp() {
    // print('OTP VTOKEN RESEND: $resendvToken');
    enableResend = false;
    BlocProvider.of<OtpBloc>(context).add(
      OtpResend(
        method: widget.parameters.data['data']['send_to'],
        sendvia: isRegisterEmail ? 'email' : 'contact',
        purpose: 'resend-register',
        vToken: resendvToken,
      ),
    );
    Timer(Duration(seconds: 60), () {
      if (!mounted) return;
      setState(() {
        enableResend = true;
      });
    });
  }

  // void _phoneConfirmPage() {
  //   // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
  //   Navigator.of(context).pushNamedAndRemoveUntil(
  //        OderRoutes.otpCValid, (Route<dynamic> route) => false,
  //       arguments: CValidOtpParameters(loginData: widget.loginData));
  // }

  void _verifyOtp() {
    setProcessingStatus(true);
    BlocProvider.of<OtpBloc>(
      context,
    ).add(OtpVerify(otpCode: otpCode, token: tokenVerify));
  }

  // void _requestOtp() {
  //   // print('OTP VTOKEN REQUEST: ${widget.parameters.data['data']['vToken']}');
  //   setProcessingStatus(true);
  //   // isChanging == true;
  //   BlocProvider.of<OtpBloc>(context).add(OtpRequest(
  //     email: widget.parameters.data['data']['email'],
  //     purpose: 'register',
  //     vToken: widget.parameters.data['data']['vToken'],
  //   ));
  // }
}
