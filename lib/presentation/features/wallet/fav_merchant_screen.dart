import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../ordering/ordering.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'wallet.dart';

class FavMerchantScreen extends StatefulWidget {
  const FavMerchantScreen({super.key});

  @override
  State<FavMerchantScreen> createState() => _FavMerchantScreenState();
}

class _FavMerchantScreenState extends State<FavMerchantScreen> {
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
          return FavMerchantWrapper();
        },
      ),
    );
  }
}

class FavMerchantWrapper extends StatefulWidget {
  const FavMerchantWrapper({super.key});

  @override
  OderWrapperState<FavMerchantWrapper> createState() =>
      _FavMerchantWrapperState();
}

class _FavMerchantWrapperState extends OderWrapperState<FavMerchantWrapper> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider<WalletBloc>(
        //   create: (context) =>
        //       WalletBloc(userRepository: sl())..add(WalletLoad()),
        // ),
        BlocProvider<OrderingBloc>(
          create:
              (context) =>
                  OrderingBloc(orderingRepository: sl())..add(OrderingCheck()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<OrderingBloc, OrderingState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);
              if (state is OrderingError) {
                showErrorToast(state.error, context);
              }
              if (state is OrderingNetworkError) {
                showErrorToast(state.error, context);
              }
              if (state is OrderingSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is OrderingMaintenanceError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.maintenanceScreen,
                  (Route<dynamic> route) => false,
                  arguments: MaintenanceParameters(message: state.message),
                );
              }
            },
          ),
        ],
        child: getPageView(<Widget>[FavMerchantView(changeView: changePage)]),
      ),
    );
  }
}
