import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../otp/otp.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'setup.dart';

class CValidOtpParameters {
  final dynamic loginData;
  final Map otpData;

  const CValidOtpParameters({required this.loginData, required this.otpData});
}

class CValidOtpScreen extends StatefulWidget {
  final CValidOtpParameters parameters;

  const CValidOtpScreen({super.key, required this.parameters});

  @override
  State<CValidOtpScreen> createState() => _CValidOtpScreenState();
}

class _CValidOtpScreenState extends State<CValidOtpScreen> {
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
              body: CValidOtpWrapper(
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

class CValidOtpWrapper extends StatefulWidget {
  final dynamic loginData;
  final Map otpData;

  const CValidOtpWrapper({super.key, this.loginData, required this.otpData});

  @override
  OderWrapperState<CValidOtpWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _CValidOtpWrapperState(loginData, otpData);
}

class _CValidOtpWrapperState extends OderWrapperState<CValidOtpWrapper> {
  final dynamic loginData;
  final Map otpData;

  _CValidOtpWrapperState(this.loginData, this.otpData);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
      child: MultiBlocListener(
        listeners: [
          BlocListener<OtpBloc, OtpState>(
            listener: (context, cValidState) {
              // if (cValidState is CvalidError) {
              //   ErrorIconDialog.showErrorDialog(context, cValidState.error);
              // }
            },
          ),
        ],
        child: getPageView(<Widget>[
          CValidOtpView(
            changeView: changePage,
            loginData: loginData,
            otpData: otpData,
          ),
        ]),
      ),
    );
  }
}
