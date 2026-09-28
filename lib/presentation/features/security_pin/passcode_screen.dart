import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../widgets/widgets.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'security_pin.dart';

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({super.key});

  @override
  State<PasscodeScreen> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        statusBarIconBrightness: Brightness.dark,
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
            body: PasscodeWrapper(),
            backgroundColor: colorBackground,
          );
        },
      ),
    );
  }
}

class PasscodeWrapper extends StatefulWidget {
  const PasscodeWrapper({super.key});

  @override
  OderWrapperState<PasscodeWrapper> createState() => _PasscodeWrapperState();
}

class _PasscodeWrapperState extends OderWrapperState<PasscodeWrapper> {
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
          PasscodeView(changeView: changePage),
          // SecurityConfirmView(changeView: changePage),
        ]),
      ),
    );
  }
}
