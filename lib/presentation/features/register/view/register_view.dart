import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../domain/domain.dart';
import '../../../widgets/widgets.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../otp/otp.dart';
// import '../../webview/webview_deeplink.dart';
import '../register.dart';

class ProfileRegView extends StatefulWidget {
  final Function changeView;
  final String referralCode;

  // ignore: use_key_in_widget_constructors
  const ProfileRegView({
    Key? key,
    required this.changeView,
    required this.referralCode,
  }) : super();

  @override
  State<ProfileRegView> createState() => _ProfileRegViewState();
}

class _ProfileRegViewState extends State<ProfileRegView> {
  bool error = false, isRegisterEmail = false;
  String selectedCode = '60';
  String passwordValid = '';
  String errorfield = '';
  String barcodeScanRes = '';
  List<String> getCode = [];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralController =
      TextEditingController(); //text: "IF21ZFGMYC"
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<OderInputFieldState> refferelKey = GlobalKey();
  // final GlobalKey<OderSelectValueState> codeKey = GlobalKey();
  final GlobalKey<OderInputFieldState> emailKey = GlobalKey();
  final GlobalKey<OderInputFieldState> passwordKey = GlobalKey();
  final GlobalKey<OderInputFieldState> confirmPasswordKey = GlobalKey();

  String otpCode = '', vToken = '';
  String errorTextEmail = '',
      errorTextPwd = '',
      errorTextCfmPwd = '',
      errorTextMissMatch = '',
      voucherAffilliateCode = '';
  late double sizeBetween;
  bool isProcessing = false;
  bool checkValueRead = false;
  bool checkValueData = false;
  late Map reqInfo;
  late FocusNode emailFocus, pwFocus, confirmPwFocus;
  final MyConnectivity _connectivity = MyConnectivity.instance;
  // final dynamicLink = FirebaseDynamicLinks.instance;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    Storage().token = '';
    // _getVoucherAffiliateCode();
    // voucherAffilliateCode = TempData.affiliateCode;
    referralController.text =
        widget.referralCode.isNotEmpty
            ? widget.referralCode
            : Storage().referralCode!.isNotEmpty
            ? Storage().referralCode!
            : '';

    emailFocus = FocusNode();
    pwFocus = FocusNode();
    confirmPwFocus = FocusNode();

    isRegisterEmail = registerMethod == 'email';
  }

  @override
  void dispose() {
    _connectivity.disposeStream();

    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();
    pwFocus.dispose();
    confirmPwFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeBetween = ScreenSize.height / 20;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? colorDarkGray : colorRed,
          selectionHandleColor: colorMulberry,
        ),
      ),
      child: Scaffold(
        backgroundColor: colorWhite,
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterMaintenanceError) {
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
            if (state is RegisterSuccess) {
              setProcessingStatus(false);
              // showSuccessToast(state.data['message'], context);

              reqInfo = state.data;
              var reqMethod =
                  isRegisterEmail
                      ? state.data['data']['email']
                      : state.data['data']['contact'];
              var reqVToken = state.data['data']['vToken'];
              Storage().referralCode = '';
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //      OderRoutes.otp, (Route<dynamic> route) => false,
              //     arguments: OtpParameters(data: state.data));
              _requestOtp(reqMethod, reqVToken);
              // Navigator.of(context).pushNamed(OderRoutes.otpVerify,
              //     arguments: OtpVerifyParameters(data: state.data));
              // Navigator.of(context).pushNamed(OderRoutes.otp,
              //     arguments: OtpParameters(data: state.data));
            }
            if (state is RegisterError) {
              // ignore: unnecessary_null_comparison
              state.error != null ? error = true : error = false;

              setProcessingStatus(false);
              showErrorToast(state.error, context);
            }
            if (state is RegisterNetworkError) {
              setProcessingStatus(false);
              showErrorToast(state.error, context);
            }
            if (state is ReferDecryptSuccess) {
              referralController.text = state.referCode;
            }
            if (state is ReferDecryptFail) {
              // setProcessingStatus(false);
              referralController.text = '';
              showErrorToast('Refferal code not valid.', context);
            }
          },
          builder: (context, state) {
            // show loading screen while processing
            if (state is RegisterProcessing) {
              // return Center(
              //   child: CircularProgressIndicator(color: colorDisableGrey,),
              // );
            }

            if (state is RegisterVerifySuccess) {
              emailController.text =
                  isRegisterEmail
                      ? state.data['data']['email']
                      : state.data['data']['contact'];
              vToken = state.data['data']['vToken'];
            }

            return BlocConsumer<OtpBloc, OtpState>(
              listener: (context, state) {
                if (state is OtpRequestSuccess) {
                  setProcessingStatus(false);
                  // resendvToken = state.data['data']['vToken'];
                  // tokenVerify = state.data['data']['token'];

                  Navigator.of(context).pushNamed(
                    OderRoutes.otpVerify,
                    arguments: OtpVerifyParameters(data: state.data),
                  );
                  showSuccessToast(state.data['message'], context);
                }
                if (state is OtpError) {
                  // ignore: unnecessary_null_comparison
                  state.error != null ? error = true : error = false;
                  setProcessingStatus(false);
                  showErrorToast(state.error, context);
                  // Navigator.of(context).pushNamed(OderRoutes.otp,
                  //     arguments: OtpVerifyParameters(data: reqInfo));
                }
              },
              builder: (context, state) {
                return Container(
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
                  child: SingleChildScrollView(
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
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            fontFamily: fontFamilyMain,
                            color: colorBlackText,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            isRegisterEmail ? 'Email' : 'Contact',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: colorTextGrey,
                            ),
                          ),
                        ),
                        OderAppTextField(
                          key: emailKey,
                          controller: emailController,
                          validator: Validator.valueExists,
                          readOnly: true,
                          focusNode: emailFocus,
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colorOutletAddressLabelGrey,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colorOutletAddressLabelGrey,
                          ),
                          onChanged: (value) {
                            if (value != '') {
                              setState(() {
                                errorfield = '';
                                error = false;
                                emailKey.currentState?.validate();
                              });
                            }
                          },
                        ),
                        SizedBox(height: ScreenSize.height * 0.01),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: colorTextGrey,
                            ),
                          ),
                        ),
                        OderAppTextField(
                          key: passwordKey,
                          controller: passwordController,
                          focusNode: pwFocus,
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: colorOutletAddressLabelGrey,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          isPassword: true,
                          textAlignVertical: TextAlignVertical.center,
                          bottomBorderColor:
                              errorfield == 'error' ||
                                      errorfield == 'errorPwd' ||
                                      errorfield == 'errorMismatch'
                                  ? colorRed
                                  : colorWhite,
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: colorOutletAddressLabelGrey,
                          ),
                          onChanged: (value) {
                            if (value != '') {
                              setState(() {
                                errorfield = '';
                                passwordKey.currentState?.validate();
                              });
                            }
                          },
                        ),
                        errorfield == 'error' ||
                                errorfield == 'errorPwd' ||
                                errorfield == 'errorMismatch'
                            ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorfield == 'error' ||
                                        errorfield == 'errorPwd'
                                    ? errorTextPwd
                                    : errorTextMissMatch,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      error
                                          ? colorRed
                                          : errorfield == 'error' ||
                                              errorfield == 'errorPwd' ||
                                              errorfield == 'errorMismatch'
                                          ? colorRed
                                          : colorGreyBox,
                                ),
                              ),
                            )
                            : Container(
                              margin: EdgeInsets.only(top: 5, left: 15),
                              child: Text(
                                'Must contain: Min. 8 characters, uppercase, lowercase, number and symbol (!@#)',
                                style: TextStyle(
                                  fontFamily: fontFamilyMain,
                                  fontSize: 10,
                                  color: colorOutletAddressLabelGrey,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                        SizedBox(height: ScreenSize.height * 0.01),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            'Confirm Password',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: colorTextGrey,
                            ),
                          ),
                        ),
                        OderAppTextField(
                          key: confirmPasswordKey,
                          controller: confirmPasswordController,
                          focusNode: confirmPwFocus,
                          hintText: 'Enter your confirm password',
                          hintStyle: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: colorOutletAddressLabelGrey,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          isPassword: true,
                          textAlignVertical: TextAlignVertical.center,
                          bottomBorderColor:
                              errorfield == 'error' ||
                                      errorfield == 'errorCfmPwd' ||
                                      errorfield == 'errorMismatch'
                                  ? colorRed
                                  : colorWhite,
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: colorOutletAddressLabelGrey,
                          ),
                          onChanged: (value) {
                            if (value != '') {
                              setState(() {
                                errorfield = '';
                                confirmPasswordKey.currentState?.validate();
                              });
                            }
                          },
                        ),
                        errorfield == 'error' ||
                                errorfield == 'errorCfmPwd' ||
                                errorfield == 'errorMismatch'
                            ? Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                errorfield == 'error' ||
                                        errorfield == 'errorCfmPwd'
                                    ? errorTextCfmPwd
                                    : errorTextMissMatch,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      error
                                          ? colorRed
                                          : errorfield == 'error' ||
                                              errorfield == 'errorCfmPwd' ||
                                              errorfield == 'errorMismatch'
                                          ? colorRed
                                          : colorGreyBox,
                                ),
                              ),
                            )
                            : Container(
                              margin: EdgeInsets.only(top: 5, left: 15),
                              child: Text(
                                'Must contain: Min. 8 characters, uppercase, lowercase, number and symbol (!@#)',
                                style: TextStyle(
                                  fontFamily: fontFamilyMain,
                                  fontSize: 10,
                                  color: colorOutletAddressLabelGrey,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                        SizedBox(height: ScreenSize.height * 0.01),
                        Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            'Referral Code (optional)',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: colorTextGrey,
                            ),
                          ),
                        ),
                        OderAppTextField(
                          key: refferelKey,
                          controller: referralController,
                          readOnly: true,
                          validator: Validator.valueExists,
                          hintText:
                              widget.referralCode.isNotEmpty
                                  ? widget.referralCode
                                  : Storage().referralCode!.isNotEmpty
                                  ? Storage().referralCode!
                                  : '-',
                          hintStyle: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colorOutletAddressLabelGrey,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: colorOutletAddressLabelGrey,
                          ),
                        ),
                        SizedBox(height: ScreenSize.height * 0.08),
                        OderCustomButton(
                          title: 'Sign Up',
                          textColor: colorWhite,
                          backgroundColor: colorMulberry,
                          borderColor: colorMulberry,
                          borderRadius: 30,
                          height: ScreenSize.height * 0.055,
                          onPressed: _validateAndSend,
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // void _onChangedRead(bool? value) {
  //   if (value != null) {
  //     setState(() {
  //       checkValueRead = value;
  //     });
  //   }
  // }

  void _showLogInScreen() {
    // Storage().dynamicLink = null;
    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.login,
      (Route<dynamic> route) => false,
    );
  }

  Future<void> scanBarcodeNormal() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (BuildContext context) =>
                AppBarcodeScannerWidget.defaultStyle(tabFor: 'register'),
      ),
    ).then((value) {
      barcodeScanRes = value.toString();

      if (value != null) {
        referDecryptValue(barcodeScanRes);
      }
    });
  }

  void referDecryptValue(String barcodeScanRes) {
    BlocProvider.of<RegisterBloc>(
      context,
    ).add(RegisterReferDecrypt(referCode: barcodeScanRes));
  }

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });
    if (passwordController.text.isEmpty &&
        confirmPasswordKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'error';
      pwFocus.requestFocus();

      errorTextPwd = 'The password is required!';
      errorTextCfmPwd = 'The confirmation password is required!';
    } else if (passwordController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'errorPwd';
      pwFocus.requestFocus();
      errorTextPwd = 'The password is required!';
      // showErrorToast('The password is required!', context);
    } else if (confirmPasswordController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'errorCfmPwd';
      confirmPwFocus.requestFocus();
      errorTextCfmPwd = 'The confirmation password is required!';
      // showErrorToast('The confirmation password is required!', context);
    } else if (Validator.passwordCorrect(passwordController.text) != null) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      pwFocus.requestFocus();
      errorTextMissMatch =
          'Must contain: Min. 8 characters, uppercase, lowercase, number and symbol (!@#)';
    } else if (passwordController.text != confirmPasswordController.text) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      confirmPwFocus.requestFocus();
      errorTextMissMatch = 'Password mismatched';
      // showErrorToast('Password mismatched', context);
      // } else if (checkValueRead == false) {
      //   errorfield = '';
      //   showErrorToast(
      //     'You must agree to the Terms and Conditions to proceed.',
      //     context,
      //   );
    } else {
      errorfield = '';
      setProcessingStatus(true);

      BlocProvider.of<RegisterBloc>(context).add(
        RegisterPressed(
          email: isRegisterEmail ? emailController.text.trim() : '',
          contact: !isRegisterEmail ? emailController.text.trim() : '',
          referral: referralController.text.trim(),
          password: confirmPasswordController.text.trim(),
          vToken: vToken,
        ),
      );
    }
  }

  void _requestOtp(String reqMethod, String reqVToken) {
    setProcessingStatus(true);
    BlocProvider.of<OtpBloc>(context).add(
      OtpRequest(
        method: reqMethod,
        sendvia: isRegisterEmail ? 'email' : 'contact',
        purpose: 'register',
        vToken: reqVToken,
      ),
    );
  }
}
