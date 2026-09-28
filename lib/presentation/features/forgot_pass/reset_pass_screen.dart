import '../../../app_setting/app_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../otp/otp.dart';
import '../wrapper.dart';
import 'forgot_pass.dart';

class ResetPassParameters {
  final String method;
  final String vToken;

  const ResetPassParameters({required this.method, required this.vToken});
}

class ResetPassScreen extends StatefulWidget {
  final ResetPassParameters? parameters;

  const ResetPassScreen({super.key, this.parameters});

  @override
  State<ResetPassScreen> createState() => _ResetPassScreenState();
}

class _ResetPassScreenState extends State<ResetPassScreen> {
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
          body: ResetPassWrapper(
            method: widget.parameters!.method,
            vToken: widget.parameters!.vToken,
          ),
        ),
      ),
    );
  }
}

class ResetPassWrapper extends StatefulWidget {
  final String method;
  final String vToken;

  const ResetPassWrapper({
    super.key,
    required this.method,
    required this.vToken,
  });

  @override
  OderWrapperState<ResetPassWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _ResetPassWrapperState(method, vToken);
}

class _ResetPassWrapperState extends OderWrapperState<ResetPassWrapper> {
  final String method;
  final String vToken;

  _ResetPassWrapperState(this.method, this.vToken);

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
          ForcePassView(changeView: changePage, method: method, vToken: vToken),
        ]),
      ),
    );
  }
}
