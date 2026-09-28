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
import 'ordering.dart';

class OrderingNearbyScreen extends StatefulWidget {
  const OrderingNearbyScreen({super.key});

  @override
  State<OrderingNearbyScreen> createState() => _OrderingNearbyScreenState();
}

class _OrderingNearbyScreenState extends State<OrderingNearbyScreen> {
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
          systemUiOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorWhiteGrey,
            statusBarIconBrightness: Brightness.dark,
          ),
          showAppbar: false,
          body: OrderingNearbyWrapper(),
          bottomMenuIndex: 1,
          isShow: true,
          canClick: true,
        );
      },
    );
  }
}

class OrderingNearbyWrapper extends StatefulWidget {
  const OrderingNearbyWrapper({super.key});

  @override
  OderWrapperState<OrderingNearbyWrapper> createState() =>
      _OrderingNearbyWrapperState();
}

class _OrderingNearbyWrapperState
    extends OderWrapperState<OrderingNearbyWrapper> {
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
        BlocProvider<OrderingBloc>(
          create: (context) {
            // Storage().orderingCheck = 1;
            return OrderingBloc(orderingRepository: sl());
          },
        ),
        // BlocProvider<RewardBloc>(create: (context) {
        //   return RewardBloc(context: context);
        // }),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<OrderingBloc, OrderingState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is OrderingError) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
                );
                showErrorToast(state.error, context);
                // ErrorDialog.showErrorDialog(context, state.error);
              }
              if (state is OrderingSessionError) {
                sessionExpiredLogOut(state.error);
              }
              /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
              if (state is OrderingMaintenanceError) {
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
        child: getPageView(<Widget>[
          OrderingNearbyView(changeView: changePage),
        ]),
      ),
    );
  }
}
