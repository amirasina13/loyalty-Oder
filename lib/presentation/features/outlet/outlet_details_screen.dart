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
import 'outlet.dart';

class OutletDetailsParameters {
  final String outletId;
  final String outlet;

  const OutletDetailsParameters({required this.outletId, required this.outlet});
}

class OutletDetailsScreen extends StatefulWidget {
  final OutletDetailsParameters parameters;

  const OutletDetailsScreen({super.key, required this.parameters});

  @override
  State<OutletDetailsScreen> createState() => _OutletDetailsScreenState();
}

class _OutletDetailsScreenState extends State<OutletDetailsScreen> {
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
            statusBarColor: colorBackground,
            statusBarIconBrightness: Brightness.dark,
          ),
          title: Text(
            widget.parameters.outlet,
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          body: OutletDetailsWrapper(outletId: widget.parameters.outletId),
          // body: BlocProvider<OutletBloc>(
          //     create: (context) {
          //       return OutletBloc()
          //         ..add(OutletDetailsLoad(
          //             outletId: (widget.parameters.outletId)));
          //     },
          //     child:
          //         OutletDetailsWrapper(outletId: widget.parameters.outletId)),
          // body: DetailsWrapper(),
          bottomMenuIndex: 3,
        );
      },
    );
  }
}

class OutletDetailsWrapper extends StatefulWidget {
  final String outletId;

  const OutletDetailsWrapper({super.key, required this.outletId});

  @override
  OderWrapperState<OutletDetailsWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _OutletDetailsWrapperState(outletId);
}

class _OutletDetailsWrapperState
    extends OderWrapperState<OutletDetailsWrapper> {
  final String outletId;

  _OutletDetailsWrapperState(this.outletId);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OutletBloc>(
          create: (context) {
            // Storage().orderingCheck = 1;
            return OutletBloc()..add(OutletDetailsLoad(outletId: (outletId)));
          },
        ),
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
          BlocListener<OutletBloc, OutletState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is OutletError) {
                showErrorToast(state.error, context);
                Navigator.pop(context);
              }
              if (state is OutletSessionError) {
                sessionExpiredLogOut(state.error);
              }
              /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
              if (state is OutletMaintenanceError) {
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
          OutletDetailsView(changeView: changePage, outletId: outletId),
        ]),
      ),
    );
  }
}
