import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../otp/otp.dart';
import '../wrapper.dart';
import 'forgot_pass.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
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
          body: ForgotPassWrapper(),
        ),
      ),
    );
  }
}

class ForgotPassWrapper extends StatefulWidget {
  const ForgotPassWrapper({super.key});

  @override
  OderWrapperState<ForgotPassWrapper> createState() =>
      _ForgotPassWrapperState();
}

class _ForgotPassWrapperState extends OderWrapperState<ForgotPassWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ForgotPassBloc>(
          create: (context) => ForgotPassBloc(userRepository: sl()),
        ),
        BlocProvider<OtpBloc>(
          create: (context) => OtpBloc(userRepository: sl()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ForgotPassBloc, ForgotPassState>(
            listener: (context, state) {
              /* ----------------------------------------------------------------- Listen to Credit error, popup error dialog */
              // if (state is ForgotPassError) {
              //   showErrorToast(state.error, context);
              // }
              // if (state is CreditNetworkError) {
              //   showErrorToast(state.error, context);
              // }
              // if (state is CreditSessionError) {
              //   sessionExpiredLogOut(state.error);
              // }
            },
          ),
          BlocListener<OtpBloc, OtpState>(
            listener: (context, state) {
              /* ----------------------------------------------------------------- Listen to Security error, popup error dialog */
              if (state is OtpError) {
                showErrorToast(state.error, context);
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          ForgetView(changeView: changePage),
          // ResetView(changeView: changePage),
        ]),
      ),
    );
  }
}
