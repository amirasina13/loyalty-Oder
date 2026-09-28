import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../../domain/domain.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../country/country.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../profile/profile.dart';
import '../../webview/webview_deeplink.dart';
import '../setup.dart';

class CValidView extends StatefulWidget {
  final Function? changeView;
  final Map profile;

  const CValidView({super.key, this.changeView, required this.profile});

  @override
  State<CValidView> createState() => _CValidViewState();
}

class _CValidViewState extends State<CValidView> {
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final GlobalKey<OderInputFieldState> _contactKey = GlobalKey();
  final GlobalKey<OderSelectValueState> codeKey = GlobalKey();
  // final GlobalKey<OderInputField> _genderKey = GlobalKey();

  String errorfield = '';

  bool isProcessing = false;
  bool error = false, isRegisterEmail = false;
  String newDate = '';
  String errorGender = '', errorContact = '';
  String resendVtoken = '';
  late FocusNode _contactFocus, _genderFocus;
  String selectedCode = '60';
  final MyConnectivity _connectivity = MyConnectivity.instance;

  List<String> getGender = ["Male", "Female"];
  List<String> getCode = [];

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  void _initDeepLinkListener() {
    _appLinks = AppLinks();
    _sub = _appLinks!.uriLinkStream.listen((uri) async {
      TempData.deeplink = uri.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    initializeDateFormatting();

    _setProfileData();

    _contactFocus = FocusNode();
    _genderFocus = FocusNode();

    if (Platform.isIOS) {
      DeepLinkHandler.listenForDeepLinkIOS();
    } else {
      _initDeepLinkListener();
    }

    isRegisterEmail = registerMethod == 'email';
  }

  @override
  void dispose() {
    _contactController.dispose();
    _genderController.dispose();

    // Clean up the focus node when the Form is disposed.
    _contactFocus.dispose();
    _genderFocus.dispose();

    _sub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetupBloc, SetupState>(
      listener: (context, state) {
        if (state is SetupContactDone) {
          setProcessingStatus(false);
          showSuccessToast(state.data['message'], context);

          // AuthFlowCoordinator.handleAuthentication(
          //   context,
          //   widget.profile,
          //   isRegisterEmail: isRegisterEmail,
          //   isMuslimFriendly: isMuslimFriendly == true,
          //   deepLink: TempData.deeplink,
          // );

          // if (!isRegisterEmail && !widget.profile['eValid']) {
          //   Storage().setupDone == false;
          //   // need to fill and get OTP
          //   if (mounted) {
          //     Navigator.of(context).pushNamedAndRemoveUntil(
          //       OderRoutes.setupEValid,
          //       (Route<dynamic> route) => false,
          //       arguments: EValidParameters(loginData: widget.profile),
          //     );
          //   }
          // } else
          if (widget.profile['vProfile'] == false) {
            Storage().setupDone == false;
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                OderRoutes.setupVProfile,
                (Route<dynamic> route) => false,
                arguments: VProfileParameters(profile: widget.profile),
              );
            }
          } else if (isMuslimFriendly == true &&
              widget.profile['vMuslim'] == false) {
            Storage().setupDone == false;
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                OderRoutes.setupVMuslim,
                (Route<dynamic> route) => false,
                arguments: VMuslimParameters(profile: widget.profile),
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
              // Storage().setupDone = null;
              Navigator.of(context).pushNamedAndRemoveUntil(
                OderRoutes.home,
                (Route<dynamic> route) => false,
              );
            }
          }
        }

        if (state is SetupContactOtp) {
          showSuccessToast(state.data['message'], context);

          Navigator.of(context)
              .pushNamed(
                OderRoutes.setupCValidOtp,
                arguments: CValidOtpParameters(
                  loginData: widget.profile,
                  otpData: state.data,
                ),
              )
              .then((value) {
                resendVtoken = state.data['data']['vToken'];
                setProcessingStatus(false);
              });
        }

        if (state is SetupMaintenanceError) {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
              builder:
                  (BuildContext context) => MaintenanceScreen(
                    parameters: MaintenanceParameters(message: state.message),
                  ),
            ),
            ModalRoute.withName('/'),
          );
        }
        if (state is SetupError) {
          setProcessingStatus(false);
          // ignore: unnecessary_null_comparison
          state.error != null ? error = true : error = false;
          showErrorToast(state.error, context);
          // ErrorDialog.showErrorDialog(context, state.error);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Container(
            // color: colorBabyBlue,
            margin: EdgeInsets.fromLTRB(
              marginHorizontal,
              20,
              marginHorizontal,
              0,
            ),
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
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
                              'assets/icons/security/verify.webp',
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
                      Text(
                        'Please enter your mobile number to receive a verification code.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: colorBlackTab,
                          // fontFamily: fontFamilyBarlow,
                        ),
                        textAlign: TextAlign.center,
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: colorBackground,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                          errorfield == 'errorcontact'
                                      ? colorRed
                                      : colorGreyBox,
                              // blurRadius: 15.0,
                              offset: Offset(
                                0.0,
                                error
                                    ? 3
                                    : errorfield == 'error' ||
                                        errorfield == 'errorcontact'
                                    ? 3
                                    : 0,
                              ),
                            ),
                          ],
                          border: Border.all(color: colorGreyBox),
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
                                key: _contactKey,
                                controller: _contactController,
                                // hint: 'Example: 123456789',
                                validator: Validator.valueExists,
                                keyboard: TextInputType.number,
                                border: InputBorder.none,
                                focusNode: _contactFocus,
                                onValueChanged: (value) {
                                  if (value != '') {
                                    setState(() {
                                      errorfield = '';
                                      error = false;
                                      _contactKey.currentState?.validate();
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      errorfield == 'error' || errorfield == 'errorcontact'
                          ? Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              errorContact,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color:
                                    error
                                        ? colorRed
                                        : errorfield == 'error' ||
                                            errorfield == 'errorcontact'
                                        ? colorRed
                                        : colorGreyBox,
                              ),
                            ),
                          )
                          : SizedBox(),
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
                        title: isProcessing ? 'Processing...' : 'Next',
                        backgroundColor:
                            isProcessing ? processing : colorMulberry,
                        textColor: isProcessing ? processingText : colorWhite,
                        onPressed:
                            isProcessing ? () {} : _validateAndUpdatePersonal,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 14, bottom: 15),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: colorBlack,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                              Container(
                                width: ScreenSize.width * 0.045,
                                height: ScreenSize.width * 0.045,
                                color: colorBackground,
                                margin: EdgeInsets.only(left: 5),
                                child: Image(
                                  image: AssetImage(
                                    'assets/icons/settings/logout.webp',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            BlocProvider.of<AuthenticationBloc>(
                              context,
                            ).add(AuthenticationLoggedOut());
                            Storage().token = '';
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              OderRoutes.login,
                              (Route<dynamic> route) => false,
                            );
                          },
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
    );
  }

  void _validateAndUpdatePersonal() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (_contactController.text.isEmpty) {
      errorfield = 'errorContact';
      _contactFocus.requestFocus();
      showErrorToast('Please enter a valid mobile number!', context);
      // ErrorIconDialog.showErrorDialog(context, 'Please enter valid email!');

      BlocProvider.of<ProfileBloc>(
        context,
      ).add(ProfileEditLoad(errorField: errorfield));
    } else {
      setProcessingStatus(true);
      Storage().contact = '$selectedCode-${_contactController.text.trim()}';

      BlocProvider.of<SetupBloc>(context).add(
        SetupContact(
          contact: '$selectedCode-${_contactController.text.trim()}',
        ),
      );
    }
  }

  // void _setProfileData(ProfileState state) {
  void _setProfileData() {
    var profile = widget.profile['profile'];

    _contactController.text =
        profile['contact'].substring(profile['contact'].indexOf("-") + 1) ?? '';

    // _genderController.text = profile['gender'] ?? '';

    selectedCode =
        profile['contact'] != ''
            ? profile['contact'].substring(0, profile['contact'].indexOf("-"))
            : '60';
  }

  List<String> _getCodes(List<Country> countries) {
    List<String> codes = [];
    for (var value in countries) {
      codes.add(value.callCode ?? '');
    }

    return codes;
  }
}
