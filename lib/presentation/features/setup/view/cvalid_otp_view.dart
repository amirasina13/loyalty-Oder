import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../otp/otp.dart';
import '../../profile/profile.dart';
import '../../webview/webview_deeplink.dart';
import '../setup.dart';

class CValidOtpView extends StatefulWidget {
  final Function? changeView;
  final dynamic loginData;
  final Map otpData;

  const CValidOtpView({
    super.key,
    this.changeView,
    this.loginData,
    required this.otpData,
  });

  @override
  State<CValidOtpView> createState() => _CValidOtpViewState();
}

class _CValidOtpViewState extends State<CValidOtpView> {
  // OtpFieldController otpController = OtpFieldController();

  String otpCode = '';
  late double sizeBetween;
  int secondsRemaining = 60;
  bool error = false;
  bool enableResend = true;
  bool isProcessing = false, isRegisterEmail = false;
  String profileCvalid = '';
  String resendvToken = '', tokenVerify = '';
  // ignore: prefer_typing_uninitialized_variables
  late Profile profile;
  final pinController = TextEditingController();
  final focusNode = FocusNode();

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;

  void _initDeepLinkListener() {
    _appLinks = AppLinks();
    _sub = _appLinks!.uriLinkStream.listen((uri) async {
      TempData.deeplink = uri.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    resendvToken = widget.otpData['data']['vToken'];
    tokenVerify = widget.otpData['data']['token'];

    if (Platform.isIOS) {
      DeepLinkHandler.listenForDeepLinkIOS();
    } else {
      _initDeepLinkListener();
    }

    isRegisterEmail = registerMethod == 'email';
  }

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    sizeBetween = ScreenSize.height / 20;

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileLoaded) {
          profile = profileState.userProfile.profile!;
        }

        return Theme(
          data: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: error == false ? colorDarkGray : colorRed,
            ),
          ),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: BlocConsumer<SetupBloc, SetupState>(
              listener: (context, state) {
                fToast = FToast();
                fToast.init(context);

                if (state is SetupFinished) {
                  showSuccessToast(state.data['message'], context);

                  // AuthFlowCoordinator.handleAuthentication(
                  //   context,
                  //   widget.loginData,
                  //   isRegisterEmail: isRegisterEmail,
                  //   isMuslimFriendly: isMuslimFriendly == true,
                  //   deepLink: TempData.deeplink,
                  // );

                  // if (!isRegisterEmail && !widget.loginData['eValid']) {
                  //   Storage().setupDone == false;
                  //   // need to fill and get OTP
                  //   if (mounted) {
                  //     Navigator.of(context).pushNamedAndRemoveUntil(
                  //       OderRoutes.setupEValid,
                  //       (Route<dynamic> route) => false,
                  //       arguments: EValidParameters(
                  //         loginData: widget.loginData,
                  //       ),
                  //     );
                  //   }
                  // }
                  // Check vProfile
                  if (widget.loginData['vProfile'] == false) {
                    Storage().setupDone == false;
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.setupVProfile,
                        (Route<dynamic> route) => false,
                        arguments: VProfileParameters(
                          profile: widget.loginData,
                        ),
                      );
                    }
                  } else if (isMuslimFriendly == true &&
                      widget.loginData['vMuslim'] == false) {
                    Storage().setupDone == false;
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.setupVMuslim,
                        (Route<dynamic> route) => false,
                        arguments: VMuslimParameters(profile: widget.loginData),
                      );
                    }
                  } else if (TempData.deeplink.isNotEmpty) {
                    Storage().setupDone = null;
                    // Navigate to webview to intercept the url - convert from short url to long url
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => RedirectWebView(
                              parameters: DeeplinkParameters(
                                initialUrl: TempData.deeplink,
                              ),
                            ),
                      ),
                    );
                  } else {
                    if (mounted) {
                      Storage().setupDone = true;
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.home,
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                }

                if (state is SetupSent) {
                  setProcessingStatus(false);

                  resendvToken = state.data['data']['vToken'];
                  tokenVerify = state.data['data']['token'];

                  showSuccessToast(state.data['message'], context);
                }

                if (state is SetupError) {
                  // ignore: unnecessary_null_comparison
                  state.error != null ? error = true : error = false;
                  setProcessingStatus(false);
                  // otpController.clear();
                  // ErrorIconDialog.showErrorDialog(context, state.error);
                  showErrorToast(state.error, context);
                }
                if (state is SetupMaintenanceError) {
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
                if (state is SetupProcessing) {}

                return SafeArea(
                  child: Container(
                    color: colorBackground,
                    margin: EdgeInsets.fromLTRB(
                      marginHorizontal,
                      20,
                      marginHorizontal,
                      0,
                    ),
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          backgroundColor: colorBackground,
                          title: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: ScreenSize.width * 0.11,
                                    height: ScreenSize.height * 0.007,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: colorMulberry,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Container(
                                    width: ScreenSize.width * 0.11,
                                    height: ScreenSize.height * 0.007,
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      color: colorPermissionGrey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Container(
                                    width: ScreenSize.width * 0.11,
                                    height: ScreenSize.height * 0.007,
                                    decoration: BoxDecoration(
                                      color: colorPermissionGrey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(
                                  'Step 1',
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: colorCountGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: ScreenSize.height * 0.05,
                                margin: EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/icons/security/confirm.webp',
                                    ),
                                    alignment: Alignment.centerLeft,
                                    colorFilter: ColorFilter.mode(
                                      colorMulberry,
                                      BlendMode.srcATop, // The blending mode
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 30, bottom: 15),
                                child: Text(
                                  'Verify your mobile number',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: colorBlackTab,
                                    // fontFamily: fontFamilyBarlow,
                                  ),
                                  textAlign: TextAlign.center,
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  // Note: Styles for TextSpans must be explicitly defined.
                                  // Child text spans will inherit styles from parent
                                  style: const TextStyle(
                                    fontSize: 11.0,
                                    color: colorBlack,
                                    fontFamily: fontFamilyMain,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          'Please enter the 6 digits code sent to ',
                                    ),
                                    TextSpan(
                                      text: '+${Storage().contact}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                color: colorTransparent,
                                height: ScreenSize.height / 15,
                                margin: EdgeInsets.only(top: 20),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                              BlocConsumer<OtpBloc, OtpState>(
                                listener: (context, state) {
                                  fToast = FToast();
                                  fToast.init(context);

                                  // on success delete navigator stack and push to home
                                  if (state is OtpFinished) {
                                    showSuccessToast(state.message, context);

                                    // Check vProfile
                                    if (!isRegisterEmail &&
                                        !widget.loginData['eValid']) {
                                      Storage().setupDone == false;
                                      // need to fill and get OTP
                                      if (mounted) {
                                        Navigator.of(
                                          context,
                                        ).pushNamedAndRemoveUntil(
                                          OderRoutes.setupEValid,
                                          (Route<dynamic> route) => false,
                                          arguments: EValidParameters(
                                            loginData: widget.loginData,
                                          ),
                                        );
                                      }
                                    } else if (widget.loginData['vProfile'] ==
                                        false) {
                                      Storage().setupDone == false;
                                      if (mounted) {
                                        Navigator.of(
                                          context,
                                        ).pushNamedAndRemoveUntil(
                                          OderRoutes.setupVProfile,
                                          (Route<dynamic> route) => false,
                                          arguments: VProfileParameters(
                                            profile: widget.loginData,
                                          ),
                                        );
                                      }
                                    } else if (isMuslimFriendly == true &&
                                        widget.loginData['vMuslim'] == false) {
                                      Storage().setupDone == false;
                                      if (mounted) {
                                        Navigator.of(
                                          context,
                                        ).pushNamedAndRemoveUntil(
                                          OderRoutes.setupVMuslim,
                                          (Route<dynamic> route) => false,
                                          arguments: VMuslimParameters(
                                            profile: widget.loginData,
                                          ),
                                        );
                                      }
                                    } else if (TempData.deeplink.isNotEmpty) {
                                      Storage().setupDone = null;
                                      // Navigate to webview to intercept the url - convert from short url to long url
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => RedirectWebView(
                                                parameters: DeeplinkParameters(
                                                  initialUrl: TempData.deeplink,
                                                ),
                                              ),
                                        ),
                                      );
                                    } else {
                                      if (mounted) {
                                        Storage().setupDone = true;
                                        Navigator.of(
                                          context,
                                        ).pushNamedAndRemoveUntil(
                                          OderRoutes.home,
                                          (Route<dynamic> route) => false,
                                        );
                                      }
                                    }
                                  }

                                  if (state is OtpResent) {
                                    setProcessingStatus(false);

                                    resendvToken = state.data['data']['vToken'];
                                    tokenVerify = state.data['data']['token'];

                                    showSuccessToast(
                                      state.data['message'],
                                      context,
                                    );
                                  }

                                  if (state is OtpError) {
                                    // ignore: unnecessary_null_comparison
                                    state.error != null
                                        ? error = true
                                        : error = false;
                                    setProcessingStatus(false);
                                    // otpController.clear();
                                    // ErrorIconDialog.showErrorDialog(context, state.error);
                                    showErrorToast(state.error, context);
                                  }
                                },
                                builder: (context, state) {
                                  return Container(
                                    height: ScreenSize.height * 0.09,
                                    width: ScreenSize.width,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 5),
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
                                                      fontFamily:
                                                          fontFamilyMain,
                                                    ),
                                                    textScaler:
                                                        TextScaler.linear(
                                                          scaleFactor,
                                                        ),
                                                  ),
                                                );
                                              },
                                              onFinished: () {},
                                            )
                                            : OderButtonText(
                                              'Resend OTP',
                                              color:
                                                  enableResend == true
                                                      ? mainColor
                                                      : colorDarkGray,
                                              onClick:
                                                  enableResend == true
                                                      ? _resendOtp
                                                      : null,
                                            ),
                                    // Text('Time left before enabling resend', style: TextStyle(),),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OderStyleButton(
                                height: ScreenSize.height / 14,
                                title:
                                    isProcessing ? 'Processing...' : 'Confirm',
                                backgroundColor:
                                    isProcessing ? processing : colorMulberry,
                                textColor:
                                    isProcessing ? processingText : colorWhite,
                                onPressed: isProcessing ? () {} : _verifyOtp,
                              ),
                              InkWell(
                                onTap: _phoneConfirmPage,
                                child: Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 15),
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  // color: colorBabyBlue,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: colorBlack,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.underline,
                                    ),
                                    textScaler: TextScaler.linear(scaleFactor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _resendOtp() {
    enableResend = false;

    BlocProvider.of<SetupBloc>(context).add(
      SetupResend(
        purpose: 'resend-register',
        contactNo: Storage().contact,
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

  void _verifyOtp() {
    setProcessingStatus(true);
    BlocProvider.of<SetupBloc>(context).add(SetupVerify(otpCode: otpCode));
  }

  void _phoneConfirmPage() {
    // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //      OderRoutes.profileExtra, (Route<dynamic> route) => false,
    //     arguments: ProfileExtraParameters(profile: widget.loginData));
    Navigator.pop(context);
  }
}
