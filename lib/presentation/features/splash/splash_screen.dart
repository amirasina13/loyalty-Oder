import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../config/config.dart';
import '../../../util/utils.dart';
import '../../widgets/widgets.dart';
import '../authentication/authentication.dart';
import '../forgot_pass/forgot_pass.dart';
import '../maintenance/maintenance_screen.dart';
import '../rewards/reward.dart';
import '../setup/setup.dart';
import '../webview/webview_deeplink.dart';
import 'splash.dart';

class SplashScreen extends StatefulWidget {
  final RemoteMessage? initialMessage;

  const SplashScreen({super.key, this.initialMessage});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String initialDeeplink = '';
  String referralCode = '';
  String voucherId = '';
  bool isRegisterEmail = false;

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;

  void _initDeepLinkListener() {
    _appLinks = AppLinks();
    _sub = _appLinks!.uriLinkStream.listen((uri) async {
      if (uri.host == AppConfig.applink) {
        TempData.deeplink = uri.toString();
      } else {
        // Optionally handle cases where the host does not match
        // debugPrint('Deep link from a different host: ${uri.host}');

        TempData.deeplink = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // _initDeepLinkListener();
    if (Platform.isIOS) {
      DeepLinkHandler.listenForDeepLinkIOS();
    } else {
      _initDeepLinkListener();
    }

    if (widget.initialMessage != null &&
        widget.initialMessage!.toMap().containsKey('data') &&
        widget.initialMessage!.data['target'] != null) {
      TempDataNotification.notificationPage =
          widget.initialMessage!.data['target'];
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorTransparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: colorTransparent,
      ),
      child: Scaffold(
        backgroundColor: colorTransparent,
        body: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) {},
          builder: (context, state) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) async {
                fToast = FToast();
                fToast.init(context);

                // isRegisterEmail = registerMethod == 'email';

                if (state is AuthenticationAuthenticated) {
                  // AuthFlowCoordinator.handleAuthentication(
                  //   context,
                  //   state.loginData,
                  //   isRegisterEmail: isRegisterEmail,
                  //   isMuslimFriendly: isMuslimFriendly == true,
                  //   deepLink: TempData.deeplink,
                  // );

                  Storage().dataCheck = state.loginData;

                  if (state.loginData['isResetPassword'] == true) {
                    Storage().setupDone = false;
                    if (mounted) {
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
                          // method:
                          //     isRegisterEmail
                          //         ? state.loginData['profile']['email']
                          //         : state.loginData['profile']['contact'],
                          method: state.loginData['profile']['email'],
                          vToken: state.loginData['vToken'],
                        ),
                      );
                    }
                  } else if (isEmailRequired && !state.loginData['eValid']) {
                    // need to fill and get OTP
                    Storage().setupDone = false;
                    if (mounted) {
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
                    }
                  } else if (!isEmailRequired && !state.loginData['eValid']) {
                    // need to fill only. No need OTP
                    Storage().setupDone = false;
                    if (mounted) {
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
                    }
                  } else if (isContactRequired && !state.loginData['cValid']) {
                    // need to fill and get OTP
                    Storage().setupDone = false;
                    Storage().welcomeSplash!.isNotEmpty
                        ? SplashTimerDialog.showSplashLoginDialog(context, () {
                          if (mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              OderRoutes.setupCValid,
                              (Route<dynamic> route) => false,
                              arguments: CValidParameters(
                                profile: state.loginData,
                              ),
                            );
                          }
                        })
                        : Navigator.of(context).pushNamedAndRemoveUntil(
                          OderRoutes.setupCValid,
                          (Route<dynamic> route) => false,
                          arguments: CValidParameters(profile: state.loginData),
                        );
                  } else if (!isContactRequired && !state.loginData['cValid']) {
                    // need to fill only. No need OTP
                    Storage().setupDone = false;
                    Storage().welcomeSplash!.isNotEmpty
                        ? SplashTimerDialog.showSplashLoginDialog(context, () {
                          if (mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              OderRoutes.setupCValid,
                              (Route<dynamic> route) => false,
                              arguments: CValidParameters(
                                profile: state.loginData,
                              ),
                            );
                          }
                        })
                        : Navigator.of(context).pushNamedAndRemoveUntil(
                          OderRoutes.setupCValid,
                          (Route<dynamic> route) => false,
                          arguments: CValidParameters(profile: state.loginData),
                        );
                  } else if (state.loginData['vProfile'] == false) {
                    Storage().setupDone = false;
                    if (mounted) {
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
                    }
                  } else if (isMuslimFriendly == true &&
                      state.loginData['vMuslim'] == false) {
                    Storage().setupDone = false;
                    if (mounted) {
                      Storage().welcomeSplash!.isNotEmpty
                          ? SplashTimerDialog.showSplashLoginDialog(
                            context,
                            () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                OderRoutes.setupVMuslim,
                                (Route<dynamic> route) => false,
                                arguments: VMuslimParameters(
                                  profile: state.loginData,
                                ),
                              );
                            },
                          )
                          : Navigator.of(context).pushNamedAndRemoveUntil(
                            OderRoutes.setupVMuslim,
                            (Route<dynamic> route) => false,
                            arguments: VMuslimParameters(
                              profile: state.loginData,
                            ),
                          );
                    }
                  } else if (TempData.deeplink.isNotEmpty) {
                    // Storage().setupDone = true;
                    // Navigate to webview to intercept the url - convert from short url to long url
                    if (mounted) {
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
                    }
                  } else {
                    // Storage().setupDone = true;

                    widget.initialMessage != null &&
                            widget.initialMessage!.toMap().containsKey('data')
                        ? widget.initialMessage?.data['target'] == 'voucher'
                            ? Navigator.of(context).pushNamedAndRemoveUntil(
                              OderRoutes.rewardDetails,
                              (Route<dynamic> route) => false,
                              arguments: RewardDetailsParameters(
                                rewardId:
                                    widget.initialMessage!.data['target_id'],

                                title:
                                    widget.initialMessage!.data['target_title'],
                                indexPage: 3,
                              ),
                            )
                            : Storage().welcomeSplash!.isNotEmpty
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
                            )
                        : Storage().welcomeSplash!.isNotEmpty
                        ? SplashTimerDialog.showSplashLoginDialog(context, () {
                          if (mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              OderRoutes.home,
                              (Route<dynamic> route) => false,
                            );
                          }
                        })
                        : Navigator.of(context).pushNamedAndRemoveUntil(
                          OderRoutes.home,
                          (Route<dynamic> route) => false,
                        );
                  }
                } else if (state is AuthenticationUnauthenticated) {
                  if (TempData.deeplink.isNotEmpty) {
                    // Storage().setupDone = true;
                    // Navigate to webview to intercept the URL - convert from short URL to long URL
                    if (mounted) {
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
                    }
                  } else {
                    // Storage().setupDone = true;
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.login,
                        (Route<dynamic> route) => false,
                      );
                    }
                  }
                } else if (state is AuthenticationOnBoardingStarted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.onBoard,
                    (Route<dynamic> route) => false,
                  );
                } else if (state is NetworkError) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.login,
                    (Route<dynamic> route) => false,
                  );
                  showErrorToast('No internet connection.', context);
                  // ErrorIconDialog.showErrorDialog(
                  //     context, 'No internet connection.');
                } else if (state is AuthenticationError) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.login,
                    (Route<dynamic> route) => false,
                  );
                  showErrorToast(state.error, context);
                } else if (state is AuthMaintenanceError) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.maintenanceScreen,
                    (Route<dynamic> route) => false,
                    arguments: MaintenanceParameters(message: state.message),
                  );
                }
              },
              child: Center(
                child: Container(
                  height: ScreenSize.height,
                  width: ScreenSize.width,
                  padding: EdgeInsets.fromLTRB(
                    marginHorizontal,
                    0,
                    // ScreenSize.height * 0.05,
                    marginHorizontal,
                    0,
                  ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/splashscreen.png'),
                      fit: BoxFit.fill,
                    ),
                  ),

                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SizedBox(
                  //       width: width * 0.35,
                  //       // margin: EdgeInsets.only(bottom: 5),
                  //       child: Text(
                  //         'Loading',
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w500,
                  //           color: colorMulberry,
                  //         ),
                  //         textAlign: TextAlign.center,
                  //       ),
                  //       // child: Image(image: AssetImage(appLogo)),
                  //     ),
                  //     LoadingAnimationWidget.horizontalRotatingDots(
                  //       color: colorMulberry,
                  //       size: width * 0.15,
                  //     ),
                  //   ],
                  // ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
