import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'security_pin.dart';

class SecurityPhoneScreen extends StatefulWidget {
  const SecurityPhoneScreen({super.key});

  @override
  State<SecurityPhoneScreen> createState() => _SecurityPhoneScreenState();
}

class _SecurityPhoneScreenState extends State<SecurityPhoneScreen> {
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
          return Scaffold(body: SecurityPhoneWrapper());
        },
      ),
    );
  }
}

class SecurityPhoneWrapper extends StatefulWidget {
  const SecurityPhoneWrapper({super.key});

  @override
  OderWrapperState<SecurityPhoneWrapper> createState() =>
      _SecurityPhoneWrapperState();
}

class _SecurityPhoneWrapperState
    extends OderWrapperState<SecurityPhoneWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create:
              (context) =>
                  ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        ),
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
              if (state is ProfileMaintenanceError) {
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
        child: getPageView(<Widget>[SecurityPhoneView(changeView: changePage)]),
      ),
    );
  }
}
