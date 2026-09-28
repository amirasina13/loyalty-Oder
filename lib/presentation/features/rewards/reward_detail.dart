import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../security_pin/security_pin.dart';
import '../voucher/voucher_screen.dart';
import '../wrapper.dart';
import 'reward.dart';

class RewardDetailsParameters {
  final String rewardId;
  final String title;
  final int indexPage;

  const RewardDetailsParameters({
    required this.rewardId,
    required this.title,
    required this.indexPage,
  });
}

class RewardDetailsScreen extends StatefulWidget {
  final RewardDetailsParameters parameters;

  const RewardDetailsScreen({super.key, required this.parameters});

  @override
  State<RewardDetailsScreen> createState() => _RewardDetailsScreenState();
}

class _RewardDetailsScreenState extends State<RewardDetailsScreen> {
  String _voucherName = '';

  void _handleVoucherNameChanged(String voucherName) {
    setState(() {
      _voucherName = voucherName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        systemNavigationBarColor: colorWhite,
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

          Storage().rewardId = widget.parameters.rewardId;
          Storage().titlePasscodeRoute =
              widget.parameters.title.isNotEmpty
                  ? widget.parameters.title
                  : _voucherName;

          return RewardDetailsWrapper(
            title: widget.parameters.title,
            indexPage: widget.parameters.indexPage,
            onVoucherNameChanged: (String value) {
              _handleVoucherNameChanged(value);
            },
          );
        },
      ),
    );
  }
}

class RewardDetailsWrapper extends StatefulWidget {
  final String title;
  final ValueChanged<String> onVoucherNameChanged;
  final int indexPage;

  const RewardDetailsWrapper({
    super.key,
    required this.title,
    required this.onVoucherNameChanged,
    required this.indexPage,
  });

  @override
  OderWrapperState<RewardDetailsWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _RewardDetailsWrapperState(title, onVoucherNameChanged, indexPage);
}

class _RewardDetailsWrapperState
    extends OderWrapperState<RewardDetailsWrapper> {
  String title;
  ValueChanged<String> onVoucherNameChanged;
  String _voucherName = '';
  bool isAbleToRedeem = false;
  int indexPage;

  _RewardDetailsWrapperState(
    this.title,
    this.onVoucherNameChanged,
    this.indexPage,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RewardBloc>(
          create: (context) {
            // ProfileBloc profileBloc = ProfileBloc(userRepository: sl());
            return RewardBloc(context: context, rewardRepository: sl())
              ..add(RewardOutletCheck());
          },
        ),
        BlocProvider<SecurityBloc>(create: (context) => SecurityBloc()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RewardBloc, RewardState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is RewardSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is RewardError) {
                // showErrorToast(state.error, context);
                // Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.voucher,
                  (Route<dynamic> route) => false,
                  arguments: VoucherParameters(
                    selectedTab: 0,
                    filterBy: 'all',
                    filterValue: '1',
                  ),
                );
              }
              if (state is RewardNetworkError) {
                showErrorToast('No internet connection', context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
                );
              }
              if (state is RewardOutletLocationRequested) {
                YesNoDialog.showYesNoDialog(
                  context,
                  'Enable Location Service',
                  Platform.isAndroid ? androidLocText : iosLocText,
                  colorBlack,
                  TextAlign.justify,
                  _buildEnableButton(context),
                );
              }
              if (state is RewardOutletLocationDisabled) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
                );
              }
              if (state is RewardDetailsLoaded) {
                setState(() {
                  _voucherName = state.details.voucher?.name ?? '';
                  onVoucherNameChanged(
                    state.details.voucher!.name!,
                  ); // Call the callback
                  isAbleToRedeem = state.details.voucher?.isAbleRedeem ?? false;
                });

                if (!isAbleToRedeem) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.voucher,
                    (Route<dynamic> route) => false,
                    arguments: VoucherParameters(
                      selectedTab: 0,
                      filterBy: 'all',
                      filterValue: '1',
                    ),
                  );
                }
              }

              if (state is RewardMaintenanceError) {
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
          BlocListener<SecurityBloc, SecurityState>(
            listener: (context, state) {
              if (state is SecuritySessionError) {
                sessionExpiredLogOut(state.error);
              }
            },
          ),
        ],
        child: getPageView(<Widget>[
          DetailsView(
            changeView: changePage,
            title:
                title != '' ? title : _voucherName, // Access widget properties

            indexPage: indexPage,
          ),
        ]),
      ),
    );
  }

  Widget _buildEnableButton(BuildContext context) {
    return OderStyleButton(
      title: 'Continue',
      backgroundColor: mainColor,
      onPressed: () async {
        BlocProvider.of<RewardBloc>(context).add(RewardOutletLocationEnable());
        Navigator.pop(context);
      },
    );
  }
}
