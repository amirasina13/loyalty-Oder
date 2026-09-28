import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../webview/webviews.dart';
import '../setup.dart';

class VMuslimView extends StatefulWidget {
  final Function? changeView;
  final Map profile;

  const VMuslimView({super.key, this.changeView, required this.profile});

  @override
  State<VMuslimView> createState() => _VMuslimViewState();
}

class _VMuslimViewState extends State<VMuslimView> {
  bool isProcessing = false, finalResult = false;
  String _result = '';
  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;
  List<String> getMuslim = [
    "Muslim-Friendly Content Only",
    "Include Non-Halal Content",
  ];

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

    if (Platform.isIOS) {
      DeepLinkHandler.listenForDeepLinkIOS();
    } else {
      _initDeepLinkListener();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SetupBloc, SetupState>(
      listener: (context, state) {
        /* --------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
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
        /* --------------------------------------------------------------------- IF Setup got error, show error message */
        if (state is SetupError) {
          setProcessingStatus(false);
          showErrorToast(state.error, context);
        }
        // if (state is SetupLoaded) {
        if (state is SetupMuslimFriendlyDone) {
          setProcessingStatus(false);
          showSuccessToast('${state.data['message']}', context);

          if (TempData.deeplink.isNotEmpty) {
            Storage().setupDone = true;
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
                              color: colorPermissionGrey,
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
                              color: colorMulberry,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          'Step 3',
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
                        margin: EdgeInsets.only(top: 30, bottom: 15),
                        child: Text(
                          'Muslim Friendly?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: colorBlackTab,
                            // fontFamily: fontFamilyBarlow,
                          ),
                          // textAlign: TextAlign.center,
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            // _result = 'No longer using the service/ platform';
                            _result = getMuslim[0];
                            finalResult = true;
                          });
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          horizontalTitleGap: -5,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color:
                                  _result == getMuslim[0]
                                      ? colorRaspberyRed
                                      : colorSocialBoxGrey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          title: Text(
                            getMuslim[0],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: fontFamilyMain,
                              color:
                                  _result == getMuslim[0]
                                      ? colorRaspberyRed
                                      : colorBlack,
                            ),
                            textScaler: TextScaler.linear(scaleFactor),
                          ),
                          trailing: Container(
                            width: 22,
                            alignment: Alignment.centerLeft,
                            child: Radio<String>(
                              value: getMuslim[0],
                              activeColor: colorRaspberyRed,
                              groupValue: _result,
                              onChanged: (value) {
                                setState(() {
                                  _result = value!;
                                  finalResult = true;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _result = getMuslim[1];
                              finalResult = false;
                            });
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            horizontalTitleGap: -5,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color:
                                    _result == getMuslim[1]
                                        ? colorRaspberyRed
                                        : colorSocialBoxGrey,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            title: Text(
                              getMuslim[1],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: fontFamilyMain,
                                color:
                                    _result == getMuslim[1]
                                        ? colorRaspberyRed
                                        : colorBlack,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                            trailing: Container(
                              width: 22,
                              alignment: Alignment.centerLeft,
                              child: Radio<String>(
                                value: getMuslim[1],
                                activeColor: colorRaspberyRed,
                                groupValue: _result,
                                onChanged: (value) {
                                  setState(() {
                                    _result = value!;
                                    finalResult = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
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
                        title: isProcessing ? 'Processing...' : 'Confirm',
                        backgroundColor:
                            isProcessing ? processing : colorMulberry,
                        textColor: isProcessing ? processingText : colorWhite,
                        onPressed: isProcessing ? () {} : _validateAndSend,
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

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (_result.isEmpty) {
      setProcessingStatus(false);
      // validateFocus.requestFocus();
      // ErrorIconDialog.showErrorDialog(context, 'Please select your reason');
      showErrorToast('Please select your reason', context);
    } else {
      setProcessingStatus(true);
      BlocProvider.of<SetupBloc>(
        context,
      ).add(SetupMuslimFriendly(isMuslim: finalResult));
    }
  }

  void _setProfileData() {
    var profile = widget.profile['profile'];

    profile['isMuslim'] == true
        ? _result = 'Muslim-Friendly Content Only'
        : _result = 'Include Non-Halal Content';
  }
}
