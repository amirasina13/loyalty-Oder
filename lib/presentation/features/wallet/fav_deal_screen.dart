import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../rewards/reward.dart';
import '../wrapper.dart';
import 'wallet.dart';

class FavDealScreen extends StatefulWidget {
  const FavDealScreen({super.key});

  @override
  State<FavDealScreen> createState() => _FavDealScreenState();
}

class _FavDealScreenState extends State<FavDealScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorWhite,
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
          return FavDealWrapper();
        },
      ),
    );
  }
}

class FavDealWrapper extends StatefulWidget {
  const FavDealWrapper({super.key});

  @override
  OderWrapperState<FavDealWrapper> createState() => _FavDealWrapperState();
}

class _FavDealWrapperState extends OderWrapperState<FavDealWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<WalletBloc>(
        //   create: (context) =>
        //       WalletBloc(userRepository: sl())..add(WalletLoad()),
        // ),
        BlocProvider<RewardBloc>(
          create:
              (context) =>
                  RewardBloc(context: context, rewardRepository: sl())
                    ..add(RewardOutletCheck()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RewardBloc, RewardState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);
              if (state is RewardError) {
                showErrorToast(state.error, context);
              }
              if (state is RewardNetworkError) {
                showErrorToast(state.error, context);
              }
              if (state is RewardSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is RewardMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.maintenanceScreen,
                  (Route<dynamic> route) => false,
                  arguments: MaintenanceParameters(message: state.message),
                );
              }
            },
          ),
        ],
        child: getPageView(<Widget>[FavDealView(changeView: changePage)]),
      ),
    );
  }
}
