import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../widgets/widgets.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'security_pin.dart';

class SecurityOtpParameters {
  final Map otpData;

  const SecurityOtpParameters({required this.otpData});
}

class SecurityOtpScreen extends StatefulWidget {
  final SecurityOtpParameters parameters;

  const SecurityOtpScreen({super.key, required this.parameters});

  @override
  State<SecurityOtpScreen> createState() => _SecurityOtpScreenState();
}

class _SecurityOtpScreenState extends State<SecurityOtpScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorWhite,
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is ProfileProcessing) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: colorWhite,
              child: LoadingWidget(),
            );
          }
          return Scaffold(
            appBar: AppBar(elevation: 0),
            body: SecurityOtpWrapper(otpData: widget.parameters.otpData),
          );
        },
      ),
    );
  }
}

class SecurityOtpWrapper extends StatefulWidget {
  final Map otpData;

  const SecurityOtpWrapper({super.key, required this.otpData});

  @override
  OderWrapperState<SecurityOtpWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _SecurityOtpWrapperState(otpData);
}

class _SecurityOtpWrapperState extends OderWrapperState<SecurityOtpWrapper> {
  final Map otpData;

  _SecurityOtpWrapperState(this.otpData);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SecurityBloc>(create: (context) => SecurityBloc()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is ProfileError) {
                showErrorToast(state.error, context);
                BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
              }
              if (state is ProfileSessionError) {
                sessionExpiredLogOut(state.error);
              }
            },
          ),
          BlocListener<SecurityBloc, SecurityState>(
            listener: (context, state) {
              if (state is SecuritySessionError) {
                sessionExpiredLogOut(state.error);
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          SecurityOtpView(changeView: changePage, otpData: otpData),
        ]),
      ),
    );
  }
}
