import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../../../widgets/widgets.dart';
import '../../country/country.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../webview/webviews.dart';
import '../../wrapper.dart';
import '../register.dart';

class RegisterView extends StatefulWidget {
  final Function changeView;
  final String referralCode;

  // ignore: use_key_in_widget_constructors
  const RegisterView({
    Key? key,
    required this.changeView,
    required this.referralCode,
  }) : super();

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool error = false;
  String errorfield = '', barcodeScanRes = '', voucherAffilliateCode = '';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralController =
      TextEditingController(); //text: "IF21ZFGMYC"
  final TextEditingController contactController = TextEditingController();
  final GlobalKey<OderInputFieldState> emailKey = GlobalKey();
  final GlobalKey<OderInputFieldState> contactKey = GlobalKey();
  final GlobalKey<OderSelectValueState> codeKey = GlobalKey();
  final GlobalKey<OderInputFieldState> refferelKey = GlobalKey();
  final GlobalKey<RedirectWebViewState> _controller = GlobalKey();

  String otpCode = '';
  String errorTextEmail = '';
  String selectedCode = '60';
  late double sizeBetween;
  List<String> getCode = [];
  bool isProcessing = false, isRegisterEmail = false;
  late FocusNode emailFocus, contactFocus;
  final MyConnectivity _connectivity = MyConnectivity.instance;

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

    emailFocus = FocusNode();
    contactFocus = FocusNode();

    voucherAffilliateCode = TempData.affiliateCode;
    referralController.text =
        widget.referralCode.isNotEmpty
            ? widget.referralCode
            : voucherAffilliateCode;

    isRegisterEmail = registerMethod == 'email';
  }

  @override
  void dispose() {
    _connectivity.disposeStream();

    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();
    contactFocus.dispose();

    super.dispose();
  }

  Future<void> _stopWebviewDeeplink() async {
    if (TempData.deeplink.isNotEmpty) {
      TempData.deeplink = '';
      _controller.currentState?.clearWebview();
    }
  }

  @override
  Widget build(BuildContext context) {
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
            if (state is ReferDecryptSuccess) {
              referralController.text = state.referCode;
            }
            if (state is ReferDecryptFail) {
              // setProcessingStatus(false);
              referralController.text = '';
              showErrorToast('Refferal code not valid.', context);
            }
            if (state is RegisterVerifySuccess) {
              setProcessingStatus(false);
              showSuccessToast(state.data['message'], context);
              Storage().referralCode = referralController.text;
              _stopWebviewDeeplink();

              widget.changeView(changeType: ViewChangeType.Forward);
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
                              errorfield == 'error' ||
                                      errorfield == 'errorEmail'
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
                                      _connectivity.myStream.listen((
                                        source,
                                      ) async {
                                        var connectionResult =
                                            await Connectivity()
                                                .checkConnectivity();

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
                      validator: Validator.valueExists,
                      hintText:
                          voucherAffilliateCode.isNotEmpty
                              ? voucherAffilliateCode
                              : widget.referralCode.isNotEmpty
                              ? widget.referralCode
                              : 'Enter your referral code',
                      hintStyle: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: colorOutletAddressLabelGrey,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      textAlignVertical: TextAlignVertical.center,
                      endIcon: InkWell(
                        child: Container(
                          margin: EdgeInsets.all(12),
                          child: Image(
                            fit: BoxFit.contain,
                            color: colorTextGrey,
                            width: ScreenSize.width * 0.05,
                            image: AssetImage(
                              'assets/icons/global/scanner.webp',
                            ),
                          ),
                        ),
                        onTap: () {
                          Storage().page = 'referral';
                          scanBarcodeNormal();
                        },
                      ),
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: colorOutletAddressLabelGrey,
                      ),
                    ),
                    SizedBox(height: ScreenSize.height * 0.08),
                    OderCustomButton(
                      title: isProcessing ? 'Processing...' : 'Next',
                      textColor: isProcessing ? processingText : colorWhite,
                      backgroundColor:
                          isProcessing ? processing : colorMulberry,
                      borderColor: isProcessing ? processing : colorMulberry,
                      borderRadius: 30,
                      height: ScreenSize.height * 0.055,
                      onPressed: isProcessing ? () {} : _validateAndSend,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<String> _getCodes(List<Country> countries) {
    List<String> codes = [];
    for (var value in countries) {
      codes.add(value.callCode ?? '');
    }

    return codes;
  }

  Future<void> scanBarcodeNormal() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (BuildContext context) =>
                AppBarcodeScannerWidget.defaultStyle(tabFor: 'checking_email'),
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

  void _showLogInScreen() {
    // Storage().dynamicLink = null;
    _stopWebviewDeeplink();

    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.login,
      (Route<dynamic> route) => false,
    );
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

    if (isFieldEmpty) {
      setProcessingStatus(false);
      errorfield = errorField;
      fieldFocus.requestFocus();
      errorTextEmail = fieldErrorMessage;
      // showErrorToast('Please enter valid email address!', context);
    } else {
      errorfield = '';
      setProcessingStatus(true);

      BlocProvider.of<RegisterBloc>(context).add(
        RegisterVerify(
          email: isRegisterEmail ? emailController.text.trim() : '',
          contact:
              !isRegisterEmail
                  ? '$selectedCode-${contactController.text.trim()}'
                  : '',
        ),
      );
    }
  }
}
