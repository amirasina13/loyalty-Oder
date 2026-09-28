import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../widgets/widgets.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'security_pin.dart';

class SecurityCreateScreen extends StatefulWidget {
  const SecurityCreateScreen({super.key});

  @override
  State<SecurityCreateScreen> createState() => _SecurityCreateScreenState();
}

class _SecurityCreateScreenState extends State<SecurityCreateScreen> {
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
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: colorBackground,
                statusBarIconBrightness: Brightness.dark,
              ),
              title: Text(
                'Set Passcode',
                style: TextStyle(
                  fontFamily: fontFamilyMain,
                  color: colorBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                textScaler: TextScaler.linear(scaleFactor),
              ),
            ),
            body: SecurityCreateWrapper(),
          );
        },
      ),
    );
  }
}

class SecurityCreateWrapper extends StatefulWidget {
  const SecurityCreateWrapper({super.key});

  @override
  OderWrapperState<SecurityCreateWrapper> createState() =>
      _SecurityCreateWrapperState();
}

class _SecurityCreateWrapperState
    extends OderWrapperState<SecurityCreateWrapper> {
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
        ],
        child: getPageView(<Widget>[
          SecurityCreateView(changeView: changePage),
        ]),
      ),
    );
  }
}
