import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../data/data.dart';
import '../../../domain/domain.dart';
import '../../widgets/widgets.dart';
import '../authentication/authentication.dart';
import '../country/country.dart';
import '../forgot_pass/forgot_pass.dart';
import '../maintenance/maintenance_screen.dart';
import '../register/register.dart';
import '../rewards/reward.dart';
import '../setup/setup.dart';
import '../splash/splash.dart';
import '../webview/webview_deeplink.dart';
import 'login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool checkValue = false;
  bool error = false;
  bool isforgotclick = false;
  String errorfield = '';
  String errorTextEmail = '', errorTextPwd = '';
  late String passwordValid = '';
  String selectedCode = '60';
  late double sizeBetween;
  List<String> getCode = [];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final GlobalKey<OderInputFieldState> emailKey = GlobalKey();
  final GlobalKey<OderInputFieldState> passwordKey = GlobalKey();
  final GlobalKey<OderInputFieldState> contactKey = GlobalKey();
  final GlobalKey<OderSelectValueState> codeKey = GlobalKey();

  bool isProcessing = false, isRegisterEmail = false;
  late FocusNode emailFocus, pwFocus, contactFocus;
  final MyConnectivity _connectivity = MyConnectivity.instance;
  Codec<String, String> infoToBase64 = utf8.fuse(base64);
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String voucherId = '';
  String initialDeeplink = '';

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    // _initDeepLinkListener();
    Storage().token = '';
    voucherId = TempData.voucherId;
    _loadUserLogin();

    fToast = FToast();
    fToast.init(context);
    emailFocus = FocusNode();
    pwFocus = FocusNode();
    contactFocus = FocusNode();

    isRegisterEmail = registerMethod == 'email';
  }

  @override
  void dispose() {
    // Dispose all text controllers
    emailController.dispose();
    passwordController.dispose();
    contactController.dispose();

    // Dispose all focus nodes
    emailFocus.dispose();
    pwFocus.dispose();
    contactFocus.dispose();

    voucherId = '';
    _connectivity.disposeStream();

    super.dispose();
  }

  click(bool isforgotclick) {
    setState(() {
      isforgotclick = isforgotclick;
    });
  }

  @override
  Widget build(BuildContext context) {
    sizeBetween = ScreenSize.height / 20;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFFfffdf6),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFfcdc8c),
      ),
      child: Theme(
        data: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: errorfield == '' ? colorDarkGray : colorRed,
            selectionHandleColor: colorMulberry,
          ),
        ),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            // resizeToAvoidBottomInset: false, // this is new
            backgroundColor: Color(0xFFfcdc8c),
            // extendBody: true,
            body: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is LoginMaintenanceError) {
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

                if (state is LoginFinished) {
                  setProcessingStatus(false);

                  if (checkValue == true) {
                    await secureStorage.write(key: 'remember', value: 'true');

                    if (isRegisterEmail) {
                      final String email = emailController.text.trim();
                      final String encodedEmail = base64Url.encode(
                        utf8.encode(email),
                      );
                      await secureStorage.write(
                        key: 'email',
                        value: encodedEmail,
                      );
                      await secureStorage.delete(key: 'contact');
                    } else {
                      final String contact = contactController.text.trim();
                      final String encodedContact = base64Url.encode(
                        utf8.encode(contact),
                      );
                      await secureStorage.write(
                        key: 'contact',
                        value: encodedContact,
                      );
                      await secureStorage.delete(key: 'email');
                    }

                    // Never store the password.
                    await secureStorage.delete(key: 'password');

                    // await secureStorage.write(
                    //   key: 'email',
                    //   value: isRegisterEmail ? emailController.text.trim() : '',
                    //   // value:
                    //   //     isRegisterEmail
                    //   //         ? emailController.text.trim()
                    //   //         : contactController.text.trim(),
                    // );
                    // await secureStorage.write(
                    //   key: 'contact',
                    //   value:
                    //       !isRegisterEmail ? contactController.text.trim() : '',
                    //   // value:
                    //   //     isRegisterEmail
                    //   //         ? emailController.text.trim()
                    //   //         : contactController.text.trim(),
                    // );
                    // // Do not store user passwords locally.
                    // await secureStorage.delete(key: 'password');
                    // // secureStorage.write(
                    // //   key: 'remember',
                    // //   value: checkValue.toString(),
                    // // );
                    // // String emailEncode = infoToBase64.encode(
                    // //   emailController.text,
                    // // );
                    // // String mobileEncode = infoToBase64.encode(
                    // //   contactController.text,
                    // // );
                    // // String passwordEncode = infoToBase64.encode(
                    // //   passwordController.text,
                    // // );

                    // // secureStorage.write(
                    // //   key: 'email',
                    // //   value: isRegisterEmail ? emailEncode : '',
                    // // );
                    // // secureStorage.write(
                    // //   key: 'contact',
                    // //   value: !isRegisterEmail ? mobileEncode : '',
                    // // );
                    // // secureStorage.write(key: 'password', value: passwordEncode);
                  } else {
                    await secureStorage.write(key: 'remember', value: 'false');
                    await secureStorage.delete(key: 'email');
                    await secureStorage.delete(key: 'contact');
                    await secureStorage.delete(key: 'password');
                    // await secureStorage.write(key: 'remember', value: 'false');
                    // await secureStorage.delete(key: 'email');
                    // await secureStorage.delete(key: 'contact');
                    // await secureStorage.delete(key: 'password');
                    // // secureStorage.write(
                    // //   key: 'remember',
                    // //   value: checkValue.toString(),
                    // // );
                    // // secureStorage.write(key: 'email', value: '');
                    // // secureStorage.write(key: 'contact', value: '');
                    // // secureStorage.write(key: 'password', value: '');
                  }

                  if (state.loginData['token'] != null) {
                    // AuthFlowCoordinator.handleAuthentication(
                    //   context,
                    //   state.loginData,
                    //   isRegisterEmail: registerMethod == 'email',
                    //   isMuslimFriendly: isMuslimFriendly == true,
                    //   // deepLink: '',
                    //   voucherId: voucherId.isNotEmpty ? voucherId : '',
                    // );
                    if (state.loginData['isResetPassword'] == true) {
                      Storage().setupDone = false;

                      if (!context.mounted) return;

                      Storage().welcomeSplash!.isNotEmpty
                          ? SplashTimerDialog.showSplashLoginDialog(
                            context,
                            () {
                              BlocProvider.of<AuthenticationBloc>(
                                context,
                              ).add(AuthenticationLoggedOut());
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                OderRoutes.login,
                                (Route<dynamic> route) => false,
                              );

                              Navigator.pushNamed(
                                context,
                                OderRoutes.resetPassword,
                                arguments: ResetPassParameters(
                                  method:
                                      isRegisterEmail
                                          ? state.loginData['profile']['email']
                                          : state
                                              .loginData['profile']['contact'],
                                  vToken: state.loginData['vToken'],
                                ),
                              );
                            },
                          )
                          : BlocProvider.of<AuthenticationBloc>(
                            context,
                          ).add(AuthenticationLoggedOut());
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.login,
                        (Route<dynamic> route) => false,
                      );

                      Navigator.pushNamed(
                        context,
                        OderRoutes.resetPassword,
                        arguments: ResetPassParameters(
                          method:
                              isRegisterEmail
                                  ? state.loginData['profile']['email']
                                  : state.loginData['profile']['contact'],
                          vToken: state.loginData['vToken'],
                        ),
                      );
                    } else if (isEmailRequired && !state.loginData['eValid']) {
                      Storage().setupDone = false;
                      // need to fill and get OTP

                      if (!context.mounted) return;
                      Storage().welcomeSplash!.isNotEmpty
                          ? SplashTimerDialog.showSplashLoginDialog(
                            context,
                            () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                OderRoutes.setupEValid,
                                (Route<dynamic> route) => false,
                                arguments: EValidParameters(
                                  loginData: state.loginData,
                                ),
                              );
                            },
                          )
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                            OderRoutes.setupEValid,
                            (Route<dynamic> route) => false,
                            arguments: EValidParameters(
                              loginData: state.loginData,
                            ),
                          );
                    } else if (!isEmailRequired && !state.loginData['eValid']) {
                      Storage().setupDone = false;
                      // need to fill only. No need OTP

                      if (!context.mounted) return;
                      Storage().welcomeSplash!.isNotEmpty
                          ? SplashTimerDialog.showSplashLoginDialog(
                            context,
                            () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                OderRoutes.setupEValid,
                                (Route<dynamic> route) => false,
                                arguments: EValidParameters(
                                  loginData: state.loginData,
                                ),
                              );
                            },
                          )
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                            OderRoutes.setupEValid,
                            (Route<dynamic> route) => false,
                            arguments: EValidParameters(
                              loginData: state.loginData,
                            ),
                          );
                    } else if (isContactRequired &&
                        !state.loginData['cValid']) {
                      Storage().setupDone = false;
                      // need to fill and get OTP

                      if (!context.mounted) return;
                      Storage().welcomeSplash!.isNotEmpty
                          ? SplashTimerDialog.showSplashLoginDialog(
                            context,
                            () {
                              if (mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  OderRoutes.setupCValid,
                                  (Route<dynamic> route) => false,
                                  arguments: CValidParameters(
                                    profile: state.loginData,
                                  ),
                                );
                              }
                            },
                          )
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                            OderRoutes.setupCValid,
                            (Route<dynamic> route) => false,
                            arguments: CValidParameters(
                              profile: state.loginData,
                            ),
                          );
                    } else if (!isContactRequired &&
                        !state.loginData['cValid']) {
                      Storage().setupDone = false;
                      // need to fill only. No need OTP
                      if (!context.mounted) return;
                      Storage().welcomeSplash!.isNotEmpty
                          ? SplashTimerDialog.showSplashLoginDialog(
                            context,
                            () {
                              if (mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  OderRoutes.setupCValid,
                                  (Route<dynamic> route) => false,
                                  arguments: CValidParameters(
                                    profile: state.loginData,
                                  ),
                                );
                              }
                            },
                          )
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                            OderRoutes.setupCValid,
                            (Route<dynamic> route) => false,
                            arguments: CValidParameters(
                              profile: state.loginData,
                            ),
                          );
                    } else if (state.loginData['vProfile'] == false) {
                      Storage().setupDone = false;

                      if (!context.mounted) return;
                      Storage().welcomeSplash!.isNotEmpty
                          ? SplashTimerDialog.showSplashLoginDialog(
                            context,
                            () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                OderRoutes.setupVProfile,
                                (Route<dynamic> route) => false,
                                arguments: VProfileParameters(
                                  profile: state.loginData,
                                ),
                              );
                            },
                          )
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                            OderRoutes.setupVProfile,
                            (Route<dynamic> route) => false,
                            arguments: VProfileParameters(
                              profile: state.loginData,
                            ),
                          );
                    } else if (isMuslimFriendly == true &&
                        state.loginData['vMuslim'] == false) {
                      Storage().setupDone = false;

                      if (!context.mounted) return;
                      Storage().welcomeSplash!.isNotEmpty
                          ? SplashTimerDialog.showSplashLoginDialog(
                            context,
                            () {
                              if (mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  OderRoutes.setupVMuslim,
                                  (Route<dynamic> route) => false,
                                  arguments: VMuslimParameters(
                                    profile: state.loginData,
                                  ),
                                );
                              }
                            },
                          )
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                            OderRoutes.setupVMuslim,
                            (Route<dynamic> route) => false,
                            arguments: VMuslimParameters(
                              profile: state.loginData,
                            ),
                          );
                    } else if (voucherId.isNotEmpty) {
                      // Storage().setupDone = true;
                      _redirectToVoucher();
                    } else {
                      // Storage().setupDone = true;
                      if (!context.mounted) return;
                      Storage().welcomeSplash!.isNotEmpty
                          ? SplashTimerDialog.showSplashLoginDialog(
                            context,
                            () {
                              if (mounted) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  OderRoutes.home,
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                          )
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                            OderRoutes.home,
                            (Route<dynamic> route) => false,
                          );
                    }
                  } else {
                    setProcessingStatus(false);
                  }
                }
                if (state is LoginError) {
                  // ignore: unnecessary_null_comparison
                  state.error != null ? error = true : error = false;

                  if (!context.mounted) return;
                  setProcessingStatus(false);
                  showErrorToast(state.error, context);
                }
                if (state is LoginNetworkError) {
                  if (!context.mounted) return;
                  setProcessingStatus(false);
                  showErrorToast(state.error, context);
                }
              },
              builder: (context, state) {
                // if (state is LoginProcessing) {
                //   return LoadingWidget();
                // }

                return Container(
                  height: ScreenSize.height,
                  width: ScreenSize.width,
                  padding: EdgeInsets.fromLTRB(
                    marginHorizontal,
                    ScreenSize.height * 0.1,
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
                    // reverse: true,
                    // physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image(
                            image: AssetImage(mainLogo),
                            height: ScreenSize.height * 0.13,
                          ),
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              fontFamily: fontFamilyMain,
                              color: colorBlackText,
                            ),
                          ),
                        ),
                        contactEmailField(),
                        SizedBox(height: ScreenSize.height * 0.01),
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          alignment: Alignment.centerLeft,
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
                          hintText: 'Enter your password',
                          focusNode: pwFocus,
                          validator: Validator.valueExists,
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
                              errorfield == 'error' || errorfield == 'errorPwd'
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
                                error = false;
                                passwordKey.currentState?.validate();
                              });
                            }
                          },
                        ),
                        errorfield == 'error' || errorfield == 'errorPwd'
                            ? Container(
                              margin: EdgeInsets.only(top: 5, left: 15),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                errorTextPwd,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      error
                                          ? colorRed
                                          : errorfield == 'error' ||
                                              errorfield == 'errorPwd'
                                          ? colorRed
                                          : colorGreyBox,
                                ),
                              ),
                            )
                            : SizedBox(),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(top: 20),
                          child: Theme(
                            data: ThemeData(
                              unselectedWidgetColor: Colors.black45,
                            ),
                            child: CheckboxListTile(
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 0,
                              ),
                              title: Text(
                                'Stay signed in?',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight:
                                      checkValue == false
                                          ? FontWeight.w400
                                          : FontWeight.w500,
                                  color:
                                      checkValue == false
                                          ? Colors.black45
                                          : colorBlack,
                                  fontFamily: fontFamilyMain,
                                ),
                              ),
                              value: checkValue,
                              onChanged: _onChangedData,
                              checkColor: colorWhite,
                              activeColor: colorMulberry,
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenSize.height * 0.02),
                        OderCustomButton(
                          title: isProcessing ? 'Processing...' : 'Sign In',
                          textColor: isProcessing ? processingText : colorWhite,
                          backgroundColor:
                              isProcessing ? processing : colorMulberry,
                          borderColor:
                              isProcessing ? processing : colorMulberry,
                          borderRadius: 30,
                          height: ScreenSize.height * 0.055,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _validateAndSend();
                          },
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: ScreenSize.width * 0.1,
                          margin: EdgeInsets.only(top: 10, bottom: 0),
                          child: InkWell(
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                fontFamily: fontFamilyMain,
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                decoration: TextDecoration.underline,
                                color: colorTextGrey,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                click(true);

                                Navigator.of(
                                  context,
                                ).pushNamed(OderRoutes.forgotPassword);
                              });
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 50, bottom: 20),
                          child: Text(
                            'Don’t have an account yet?',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colorTextGrey,
                              // decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        OderCustomButton(
                          title: 'Register',
                          textColor: colorBlackText,
                          backgroundColor: colorSunglow,
                          borderRadius: 30,
                          height: ScreenSize.height * 0.055,
                          onPressed: _registerNow,
                        ),
                        // SizedBox(height: ScreenSize.height * 0.05),

                        // Container(
                        //   height: ScreenSize.height * 0.05,
                        //   color: colorWhite,
                        // ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget contactEmailField() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 30),
          alignment: Alignment.centerLeft,
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
        isRegisterEmail
            ? OderAppTextField(
              key: emailKey,
              controller: emailController,
              hintText: 'Enter your email',
              focusNode: emailFocus,
              keyboardType: TextInputType.emailAddress,
              hintStyle: TextStyle(
                fontFamily: fontFamilyMain,
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: colorOutletAddressLabelGrey,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              bottomBorderColor:
                  errorfield == 'error' || errorfield == 'errorEmail'
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
                    error = false;
                    emailKey.currentState?.validate();
                  });
                }
              },
            )
            : Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color:
                        error
                            ? colorRed
                            : errorfield == 'error' ||
                                errorfield == 'errorcontact'
                            ? colorRed
                            : colorWhite,
                  ),
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Row(
                children: [
                  BlocProvider<CountryBloc>(
                    create: (context) {
                      // creditRecords.clear();
                      return CountryBloc()..add(CountryLoad());
                    },
                    child: BlocConsumer<CountryBloc, CountryState>(
                      listener: (context, state) {
                        if (state is CountryError) {
                          showErrorToast(state.error, context);
                          // ErrorDialog.showErrorDialog(
                          //     context, state.error);
                        }
                      },
                      builder: (context, state) {
                        if (state is CountryListLoaded) {
                          getCode = _getCodes(state.countries);
                        }

                        if (state is CountryNetworkError) {
                          _connectivity.initialise();
                          _connectivity.myStream.listen((source) async {
                            var connectionResult =
                                await Connectivity().checkConnectivity();

                            if (connectionResult.contains(
                                  ConnectivityResult.mobile,
                                ) &&
                                connectionResult.contains(
                                  ConnectivityResult.wifi,
                                )) {
                              if (!context.mounted) return;
                              BlocProvider.of<CountryBloc>(
                                context,
                              ).add(CountryLoad());
                            }
                          });
                        }

                        return OderSelectValue(
                          key: codeKey,
                          availableValues: getCode,
                          selectedValue: selectedCode,
                          hint: 'Code',
                          color: colorTransparent,
                          dropdownColor: colorLightYellow,
                          onClick:
                              ((String selectedValue) => {
                                selectedCode = selectedValue,
                              }),
                          width: ScreenSize.width * 0.3,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: OderInputField(
                      key: contactKey,
                      controller: contactController,
                      hint: 'Example: 123456789',
                      color: colorTransparent,
                      validator: Validator.valueExists,
                      keyboard: TextInputType.number,
                      border: InputBorder.none,
                      focusNode: contactFocus,
                      onValueChanged: (value) {
                        if (value != '') {
                          setState(() {
                            errorfield = '';
                            error = false;
                            contactKey.currentState?.validate();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        errorfield == 'error' ||
                (isRegisterEmail
                    ? errorfield == 'errorEmail'
                    : errorfield == 'errorcontact')
            ? Container(
              margin: EdgeInsets.only(top: 5, left: 15),
              alignment: Alignment.centerLeft,
              child: Text(
                errorTextEmail,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color:
                      error
                          ? colorRed
                          : errorfield == 'error' ||
                              (isRegisterEmail
                                  ? errorfield == 'errorEmail'
                                  : errorfield == 'errorcontact')
                          ? colorRed
                          : colorGreyBox,
                ),
              ),
            )
            : SizedBox(),
      ],
    );
  }

  List<String> _getCodes(List<Country> countries) {
    List<String> codes = [];
    for (var value in countries) {
      codes.add(value.callCode ?? '');
    }

    return codes;
  }

  void _onChangedData(bool? value) {
    if (value != null) {
      setState(() {
        checkValue = value;
      });
    }
  }

  void _registerNow() {
    Navigator.of(context).pushNamed(
      OderRoutes.register,
      arguments: RegisterParameters(referralCode: ''),
    );
  }

  void _redirectToVoucher() {
    if (mounted) {
      Storage().welcomeSplash!.isNotEmpty
          ? SplashTimerDialog.showSplashLoginDialog(context, () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              OderRoutes.rewardDetails,
              arguments: RewardDetailsParameters(
                rewardId: voucherId,
                title: '',
                indexPage: 3,
              ),
              (Route<dynamic> route) => true,
            );
          })
          : Navigator.of(context).pushNamedAndRemoveUntil(
            OderRoutes.rewardDetails,
            arguments: RewardDetailsParameters(
              rewardId: voucherId,
              title: '',
              indexPage: 3,
            ),
            (Route<dynamic> route) => true,
          );
    }
  }

  void _validateAndSend() {
    final bool isFieldEmpty =
        isRegisterEmail
            ? emailController.text.isEmpty
            : contactController.text.isEmpty;

    final String fieldErrorMessage =
        isRegisterEmail
            ? 'The email address is required!'
            : 'The contact number is required!';

    final String errorField = isRegisterEmail ? 'errorEmail' : 'errorcontact';

    final FocusNode fieldFocus = isRegisterEmail ? emailFocus : contactFocus;

    if (isFieldEmpty && passwordController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'error';
      fieldFocus.requestFocus();
      errorTextEmail = fieldErrorMessage;
      errorTextPwd = 'The password is required!';
    } else if (isFieldEmpty) {
      setProcessingStatus(false);
      errorfield = errorField;
      fieldFocus.requestFocus();
      errorTextEmail = fieldErrorMessage;
      // showErrorToast('Email address is required !', context);
    } else if (passwordController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'errorPwd';
      pwFocus.requestFocus();
      errorTextPwd = 'The password is required!';
      // showErrorToast('Password is required !', context);
    } else {
      errorfield = '';
      Storage().contact = '$selectedCode-${contactController.text.trim()}';

      setProcessingStatus(true);
      BlocProvider.of<LoginBloc>(context).add(
        LoginPressed(
          email: isRegisterEmail ? emailController.text.trim() : '',
          contact:
              !isRegisterEmail
                  ? '$selectedCode-${contactController.text.trim()}'
                  : '',
          password: passwordController.text.trim(), //passwordValid.trim(),
        ),
      );
    }
  }

  void _loadUserLogin() async {
    String? encryptedEmail = await secureStorage.read(key: 'email');
    String? encryptedContact = await secureStorage.read(key: 'contact');
    String? remember = await secureStorage.read(key: 'remember');
    // String? valuePw = await secureStorage.read(key: 'password');

    try {
      if (remember == 'true') {
        if (!mounted) return;
        setState(() {
          checkValue = true;
        });

        // Check save data match or not with backend register method
        bool hasEmailInContact =
            isRegisterEmail == false && (encryptedEmail?.isNotEmpty ?? false);
        bool hasContactInEmail =
            isRegisterEmail == true && (encryptedContact?.isNotEmpty ?? false);

        // If have conflict, clear everything
        if (hasEmailInContact || hasContactInEmail) {
          _clearForm();
          return;
        }

        String? targetValue =
            isRegisterEmail ? encryptedEmail : encryptedContact;

        // Handle Email or Contact field
        if (targetValue != null && targetValue.isNotEmpty) {
          String decodedValue = utf8.decode(base64Url.decode(targetValue));

          if (isRegisterEmail) {
            emailController.text = decodedValue;
            contactController.clear();
          } else {
            contactController.text = decodedValue;
            emailController.clear();
          }
        }

        // String? valuePw = await secureStorage.read(key: 'password');
        // print('ENCRYPTED VALUE: $valuePw');
        // if (valuePw != null && valuePw.isNotEmpty) {
        //   passwordController.text = utf8.decode(base64Url.decode(valuePw));
        // }
        passwordController.clear();
      } else {
        // If remember is false, clear everything
        _clearForm();
      }
    } catch (e) {
      _clearForm();
      e;
    }
  }

  void _clearForm() {
    emailController.clear();
    contactController.clear();
    passwordController.clear();
    checkValue = false;
  }
}
