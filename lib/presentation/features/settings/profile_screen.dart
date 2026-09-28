import 'dart:io';

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
import 'setting.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // systemNavigationBarColor: colorTransparent,
        // systemNavigationBarIconBrightness: Brightness.dark,
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
            child: OderScaffold(
              // systemUiOverlayStyle: SystemUiOverlayStyle(
              //   statusBarColor: colorBackground,
              //   statusBarIconBrightness: Brightness.dark,
              //   systemNavigationBarColor: colorTransparent,
              // ),
              extendBodyBehindAppBar: false,
              title: Text(
                'User Profile',
                style: TextStyle(
                  fontFamily: fontFamilyMain,
                  color: colorBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                textScaler: TextScaler.linear(scaleFactor),
              ),
              leading: IconButton(
                icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                ),
                onPressed: () {
                  // Storage().page != 'card'
                  // ? Navigator.of(context).pushNamedAndRemoveUntil(
                  //     OderRoutes.setting,
                  //     (Route<dynamic> route) => false,
                  //   )
                  // :
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.wallet,
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              body: ProfileWrapper(),
              bottomMenuIndex: 4,
              showBottomNavigator: false,
            ),
          );
        },
      ),
    );
  }
}

class ProfileWrapper extends StatefulWidget {
  const ProfileWrapper({super.key});

  @override
  OderWrapperState<ProfileWrapper> createState() => _ProfileWrapperState();
}

class _ProfileWrapperState extends OderWrapperState<ProfileWrapper> {
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create:
              (context) =>
                  ProfileBloc(userRepository: sl())..add(ProfileLoad()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileError) {
                showErrorToast(state.error, context);
                BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
              }

              if (state is ProfileSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is ProfileMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.maintenanceScreen,
                  (Route<dynamic> route) => false,
                  arguments: MaintenanceParameters(message: state.message),
                );
              }
            },
          ),
        ],
        child: getPageView(<Widget>[ProfileView(changeView: changePage)]),
      ),
    );
  }
}
