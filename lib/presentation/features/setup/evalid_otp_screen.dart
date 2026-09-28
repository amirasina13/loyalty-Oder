import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/independent/loading_widget.dart';
import '../otp/otp.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'setup.dart';

class EValidOtpParameters {
  final dynamic loginData;
  final Map otpData;

  const EValidOtpParameters({required this.loginData, required this.otpData});
}

class EValidOtpScreen extends StatefulWidget {
  final EValidOtpParameters parameters;

  const EValidOtpScreen({super.key, required this.parameters});

  @override
  State<EValidOtpScreen> createState() => _EValidOtpScreenState();
}

class _EValidOtpScreenState extends State<EValidOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        systemNavigationBarColor: colorWhite,
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileProcessing) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: colorWhite,
              child: LoadingWidget(),
            );
          }

          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: colorWhite,
              // appBar: AppBar(
              //   title: Text(
              //     'Otp Verification',
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
              body: EValidOtpWrapper(
                loginData: widget.parameters.loginData,
                otpData: widget.parameters.otpData,
              ),
            ),
          );
        },
      ),
    );
  }
}

class EValidOtpWrapper extends StatefulWidget {
  final dynamic loginData;
  final Map otpData;

  const EValidOtpWrapper({super.key, this.loginData, required this.otpData});

  @override
  OderWrapperState<EValidOtpWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _EValidOtpWrapperState(loginData, otpData);
}

class _EValidOtpWrapperState extends OderWrapperState<EValidOtpWrapper> {
  final dynamic loginData;
  final Map otpData;

  _EValidOtpWrapperState(this.loginData, this.otpData);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<EvalidOtpBloc>(
        //   create: (context) =>
        //       EvalidOtpBloc(userRepository: sl())..add(EvalidOtpLoad()),
        // ),
        BlocProvider<SetupBloc>(
          create: (context) => SetupBloc(userRepository: sl()),
        ),
        BlocProvider<OtpBloc>(
          create: (context) => OtpBloc(userRepository: sl()),
        ),
        // BlocProvider<ProfileBloc>(
        //   create: (context) =>
        //       ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        // ),
      ],
      // child: MultiBlocListener(
      //   listeners: [
      //     // BlocListener<EvalidOtpBloc, EvalidOtpState>(
      //     //   listener: (context, cValidState) {
      //     //     // if (cValidState is CvalidError) {
      //     //     //   ErrorIconDialog.showErrorDialog(context, cValidState.error);
      //     //     // }
      //     //   },
      //     // ),
      //   ],
      child: getPageView(<Widget>[
        EvalidOtpView(
          changeView: changePage,
          loginData: loginData,
          otpData: otpData,
        ),
      ]),
      // ),
    );
  }
}
