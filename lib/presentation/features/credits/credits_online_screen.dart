import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../security_pin/security_pin.dart';
import '../wrapper.dart';
import 'credits.dart';

class CreditOnlineScreen extends StatefulWidget {
  const CreditOnlineScreen({super.key});

  @override
  State<CreditOnlineScreen> createState() => _CreditOnlineScreenState();
}

class _CreditOnlineScreenState extends State<CreditOnlineScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, profileState) {
        if (profileState is ProfileProcessing) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: colorWhite,
            child: LoadingWidget(),
          );
        }
        /* --------------------------------------------------------------------- Topup credit appbar */
        return OderScaffold(
          systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorRedDark,
            statusBarIconBrightness: Brightness.light,
          ),
          title: Text(
            'Top-Up',
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorWhite,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: colorWhite,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          appBarColor: colorRedDark,
          body: CreditOnlineWrapper(),
          bottomMenuIndex: 0,
        );
      },
    );
  }
}

class CreditOnlineWrapper extends StatefulWidget {
  const CreditOnlineWrapper({super.key});

  @override
  OderWrapperState<CreditOnlineWrapper> createState() =>
      _CreditOnlineWrapperState();
}

class _CreditOnlineWrapperState extends OderWrapperState<CreditOnlineWrapper> {
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
        BlocProvider<CreditBloc>(
          create: (context) => CreditBloc(creditRepository: sl()),
        ),
        BlocProvider<SecurityBloc>(create: (context) => SecurityBloc()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
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
          // BlocListener<CreditBloc, CreditState>(listener: (context, state) {
          //   /* ----------------------------------------------------------------- Listen to Credit error, popup error dialog */
          //   if (state is CreditError) {
          //     showErrorToast(state.error, context);
          //   }
          //   if (state is CreditNetworkError) {
          //     showErrorToast(state.error, context);
          //   }
          //   if (state is CreditSessionError) {
          //     sessionExpiredLogOut(state.error);
          //   }
          // }),
          BlocListener<SecurityBloc, SecurityState>(
            listener: (context, state) {
              /* ----------------------------------------------------------------- Listen to Security error, popup error dialog */
              if (state is SecurityNetworkError) {
                showErrorToast(state.error, context);
              }
              if (state is SecuritySessionError) {
                sessionExpiredLogOut(state.error);
              }
            },
          ),
        ],
        child: getPageView(<Widget>[CreditOnlineView(changeView: changePage)]),
      ),
    );
  }
}
