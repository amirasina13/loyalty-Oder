import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../profile/profile.dart';
import '../rewards/reward.dart';
import '../wrapper.dart';
import 'voucher.dart';

class VoucherParameters {
  final int selectedTab;
  final String filterBy;
  final String filterValue;

  const VoucherParameters({
    required this.selectedTab,
    required this.filterBy,
    required this.filterValue,
  });
}

class VoucherScreen extends StatefulWidget {
  final VoucherParameters parameters;

  const VoucherScreen({super.key, required this.parameters});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
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
          return VoucherWrapper(
            selectedTab: widget.parameters.selectedTab,
            filterBy: widget.parameters.filterBy,
            filterValue: widget.parameters.filterValue,
          );
        },
      ),
    );
  }
}

class VoucherWrapper extends StatefulWidget {
  final int selectedTab;
  final String filterBy;
  final String filterValue;
  final int? filterIndex;

  const VoucherWrapper({
    super.key,
    required this.selectedTab,
    required this.filterBy,
    required this.filterValue,
    this.filterIndex,
  });

  @override
  OderWrapperState<VoucherWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _VoucherWrapperState(selectedTab, filterBy, filterValue);
}

class _VoucherWrapperState extends OderWrapperState<VoucherWrapper> {
  // ignore: prefer_typing_uninitialized_variables
  var selectedTab;
  String filterBy;
  String filterValue;

  _VoucherWrapperState(this.selectedTab, this.filterBy, this.filterValue);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RewardBloc>(
          create:
              (context) => RewardBloc(context: context, rewardRepository: sl()),
          // ..add(FilterCategoryLoad()),
          //..add(FilterCategoryLoad()
        ),
        BlocProvider<VoucherBloc>(
          create: (context) => VoucherBloc(),
          // ..add(VoucherCategoriesLoad()),
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
              if (state is RewardSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is RewardNetworkError) {
                showErrorToast('No internet connection', context);
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   OderRoutes.home,
                //   (Route<dynamic> route) => false,
                // );
              }
              if (state is RewardOutletLocationDisabled) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
          BlocListener<VoucherBloc, VoucherState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is VoucherError) {
                showErrorToast(state.error, context);
              }
              if (state is VoucherSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is VoucherNetworkError) {
                showErrorToast('No internet connection', context);
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   OderRoutes.home,
                //   (Route<dynamic> route) => false,
                // );
              }
              if (state is VoucherOutletLocationDisabled) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          // TestTab(),
          VoucherView(
            changeView: changePage,
            selectedTab: selectedTab,
            filterBy: filterBy,
            filterValue: filterValue,
          ),
        ]),
      ),
    );
  }
}
