import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../refer/refer.dart';
import '../wrapper.dart';
import 'setting.dart';

class ReferScreen extends StatefulWidget {
  const ReferScreen({super.key});

  @override
  State<ReferScreen> createState() => _ReferScreenState();
}

class _ReferScreenState extends State<ReferScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileProcessing) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: colorWhite,
            child: LoadingWidget(),
          );
        }
        return OderScaffold(
          showAppbar: false,
          // ),
          body: ReferWrapper(),
          bottomMenuIndex: 3,
          isShow: false,
          systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorWhite,
            statusBarIconBrightness: Brightness.dark,
          ),
        );
      },
    );
  }
}

class ReferWrapper extends StatefulWidget {
  const ReferWrapper({super.key});

  @override
  OderWrapperState<ReferWrapper> createState() => _ReferWrapperState();
}

class _ReferWrapperState extends OderWrapperState<ReferWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReferBloc>(
          create:
              (context) => ReferBloc(userRepository: sl())..add(ReferLoad()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) {
            return ProfileBloc(userRepository: sl())..add(ProfileLoad());
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ReferBloc, ReferState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is ReferError) {
                showErrorToast(state.error, context);
                BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
              }
              if (state is ReferNetworkError) {
                showErrorToast(state.error, context);
                Navigator.pop(context);
              }
              if (state is ReferSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is ReferMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.maintenanceScreen,
                  (Route<dynamic> route) => false,
                  arguments: MaintenanceParameters(message: state.message),
                );
              }
            },
          ),
        ],
        child: getPageView(<Widget>[ReferView(changeView: changePage)]),
        // ),
      ),
    );
  }
}
