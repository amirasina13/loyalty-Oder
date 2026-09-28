import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../ordering/ordering.dart';
import '../profile/profile.dart';
import '../wrapper.dart';
import 'reward.dart';

class RewardOutletDetailsParameters {
  final String outletId;
  final String outletName;

  const RewardOutletDetailsParameters({
    required this.outletId,
    required this.outletName,
  });
}

class RewardOutletDetailsScreen extends StatefulWidget {
  final RewardOutletDetailsParameters parameters;

  const RewardOutletDetailsScreen({super.key, required this.parameters});

  @override
  State<RewardOutletDetailsScreen> createState() =>
      _RewardOutletDetailsScreenState();
}

class _RewardOutletDetailsScreenState extends State<RewardOutletDetailsScreen> {
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
            widget.parameters.outletName,
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          body: RewardOutletDetailsWrapper(
            outletId: widget.parameters.outletId,
          ),
          bottomMenuIndex: 0,
        );
      },
    );
  }
}

class RewardOutletDetailsWrapper extends StatefulWidget {
  final String outletId;

  const RewardOutletDetailsWrapper({super.key, required this.outletId});

  @override
  OderWrapperState<RewardOutletDetailsWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _RewardOutletDetailsWrapperState(outletId);
}

class _RewardOutletDetailsWrapperState
    extends OderWrapperState<RewardOutletDetailsWrapper> {
  final String outletId;

  _RewardOutletDetailsWrapperState(this.outletId);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RewardBloc>(
          create: (context) {
            // Storage().orderingCheck = 1;
            return RewardBloc(context: context, rewardRepository: sl())
              ..add(RewardOutletDetailsLoad(outletId: (outletId)));
          },
        ),
        BlocProvider<OrderingBloc>(
          create: (context) {
            // Storage().orderingCheck = 1;
            return OrderingBloc(orderingRepository: sl());
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RewardBloc, RewardState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is RewardError) {
                Navigator.pop(context);

                showErrorToast(state.error, context);
              }
              if (state is RewardSessionError) {
                sessionExpiredLogOut(state.error);
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          RewardOutletDetailsView(changeView: changePage, outletId: outletId),
        ]),
      ),
    );
  }
}
