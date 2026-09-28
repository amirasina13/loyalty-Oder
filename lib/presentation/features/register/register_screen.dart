import '../../../app_setting/app_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance.dart';
import '../otp/otp.dart';
import '../webview/webview_deeplink.dart';
import '../wrapper.dart';
import 'register.dart';

class RegisterParameters {
  final String referralCode;

  const RegisterParameters({required this.referralCode});
}

class RegisterScreen extends StatefulWidget {
  final RegisterParameters parameters;

  const RegisterScreen({super.key, required this.parameters});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String affiliateCode = '';

  @override
  void initState() {
    super.initState();

    affiliateCode = TempData.affiliateCode;
  }

  @override
  void dispose() {
    affiliateCode = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFFfffdf6),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFfcdc8c),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: colorBackground,
          // appBar: AppBar(
          //   leading: Container(),
          //   title: Text(
          //     'Create Account',
          //     style: TextStyle(
          //       fontFamily: fontFamilyMain,
          //       color: colorBlack,
          //       fontWeight: FontWeight.w400,
          //       fontSize: 15,
          //     ),
          //     textScaler: TextScaler.linear(scaleFactor),
          //   ),
          //   centerTitle: true,
          //   elevation: 0,
          // ),
          body: RegisterWrapper(
            referralCode:
                widget.parameters.referralCode.isNotEmpty
                    ? widget.parameters.referralCode
                    : affiliateCode,
          ),
        ),
      ),
    );
  }
}

class RegisterWrapper extends StatefulWidget {
  final String referralCode;

  const RegisterWrapper({super.key, required this.referralCode});

  @override
  OderWrapperState<RegisterWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _RegisterWrapperState(referralCode);
}

class _RegisterWrapperState extends OderWrapperState<RegisterWrapper> {
  String referralCode;
  _RegisterWrapperState(this.referralCode);

  String email = '';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(
          create: (context) {
            // Storage().orderingCheck = 1;
            return RegisterBloc(userRepository: sl());
          },
        ),
        BlocProvider<OtpBloc>(
          create: (context) {
            return OtpBloc(userRepository: sl());
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              // if (state is RegisterError) {
              //   Navigator.of(context).pushNamedAndRemoveUntil(
              //     OderRoutes.login,
              //     (Route<dynamic> route) => false,
              //   );
              //   showErrorToast(state.error, context);
              //   // ErrorDialog.showErrorDialog(context, state.error);
              // }
              /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
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
            },
          ),
        ],
        child: getPageView(<Widget>[
          RegisterView(changeView: changePage, referralCode: referralCode),
          ProfileRegView(changeView: changePage, referralCode: referralCode),
        ]),
      ),
    );
    // return BlocProvider<RegisterBloc>(
    //   create: (context) {
    //     // Call CountryListLoad() event in CountryBloc to get Country list from API
    //     return RegisterBloc(userRepository: sl());
    //   },
    //   child: BlocConsumer<RegisterBloc, RegisterState>(
    //     listener: (context, state) {
    //       // Listen is state return error, popup error dialog
    //     },
    //     builder: (context, state) {
    //       // Show content view for bulletin details

    //       return getPageView(<Widget>[
    //         RegisterView(
    //           changeView: changePage,
    //           referralCode: referralCode,
    //         ),
    //         ProfileRegView(
    //           changeView: changePage,
    //           referralCode: referralCode,
    //         ),
    //       ]);
    //     },
    //   ),
    // );
  }
}
