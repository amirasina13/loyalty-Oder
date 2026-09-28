import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance.dart';
import '../profile/profile.dart';
import '../security_pin/security_pin.dart';
import '../wrapper.dart';
import 'reward.dart';

class RewardConfirmParameters {
  final dynamic voucherInfo;
  final int indexPage;
  final String? either;

  const RewardConfirmParameters({
    required this.voucherInfo,
    required this.indexPage,
    this.either,
  });
}

class RewardConfirmScreen extends StatefulWidget {
  final RewardConfirmParameters parameters;

  const RewardConfirmScreen({super.key, required this.parameters});

  @override
  State<RewardConfirmScreen> createState() => _RewardConfirmScreenState();
}

class _RewardConfirmScreenState extends State<RewardConfirmScreen> {
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
          title: Text(
            'Confirm Payment',
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          body: RewardConfirmWrapper(
            voucherInfo: widget.parameters.voucherInfo,
            either: widget.parameters.either,
            // points: widget.parameters.points,
            // credits: widget.parameters.credits,
          ),
          bottomMenuIndex: widget.parameters.indexPage == 0 ? 0 : 3,
        );
      },
    );
  }
}

class RewardConfirmWrapper extends StatefulWidget {
  final dynamic voucherInfo;
  final String? either;

  const RewardConfirmWrapper({
    super.key,
    required this.voucherInfo,
    this.either,
  });

  @override
  OderWrapperState<RewardConfirmWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _RewardConfirmWrapperState(voucherInfo, either);
}

class _RewardConfirmWrapperState
    extends OderWrapperState<RewardConfirmWrapper> {
  // ignore: prefer_typing_uninitialized_variables
  dynamic voucherInfo;
  String? either;

  _RewardConfirmWrapperState(this.voucherInfo, this.either);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RewardBloc>(
          create: (context) {
            return RewardBloc(context: context, rewardRepository: sl())
              ..add(RewardOutletCheck());
          },
        ),
        BlocProvider<SecurityBloc>(
          create: (context) {
            return SecurityBloc();
          },
        ),
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
                showErrorToast(state.error, context);
                Navigator.pop(context);
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

              /* --------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
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
          RewardConfirm(
            changeView: changePage,
            voucherInfo: voucherInfo,
            either: either,
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
