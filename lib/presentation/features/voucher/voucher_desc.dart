import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../app_setting/app_setting.dart';
import '../../widgets/widgets.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../security_pin/security_pin.dart';
import '../wrapper.dart';
import 'voucher.dart';

class VoucherDescParameters {
  final String voucherId;
  final String title;

  const VoucherDescParameters({required this.voucherId, required this.title});
}

class VoucherDescScreen extends StatefulWidget {
  final VoucherDescParameters parameters;

  const VoucherDescScreen({super.key, required this.parameters});

  @override
  State<VoucherDescScreen> createState() => _VoucherDescScreenState();
}

class _VoucherDescScreenState extends State<VoucherDescScreen> {
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
        Storage().voucherId = widget.parameters.voucherId;
        Storage().titlePasscodeRoute = widget.parameters.title;

        return VoucherDescWrapper(title: widget.parameters.title);
      },
    );
  }
}

class VoucherDescWrapper extends StatefulWidget {
  final String title;

  const VoucherDescWrapper({super.key, required this.title});

  @override
  OderWrapperState<VoucherDescWrapper> createState() =>
  // ignore: no_logic_in_create_state
  _VoucherDescWrapperState(title);
}

class _VoucherDescWrapperState extends OderWrapperState<VoucherDescWrapper> {
  // ignore: prefer_typing_uninitialized_variables
  var title;

  _VoucherDescWrapperState(this.title);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VoucherBloc>(
          create: (context) {
            return VoucherBloc()..add(VoucherOutletCheck());
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
          BlocListener<VoucherBloc, VoucherState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is VoucherError) {
                // BlocProvider.of<VoucherBloc>(context).add(VoucherOutletCheck());
                showErrorToast(state.error, context);

                Navigator.pop(context);
              }
              if (state is VoucherSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is VoucherNetworkError) {
                showErrorToast('No internet connection', context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
                );
              }
              /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
              if (state is VoucherMaintenanceError) {
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
              if (state is VoucherOutletLocationRequested) {
                YesNoDialog.showYesNoDialog(
                  context,
                  'Enable Location Service',
                  Platform.isAndroid ? androidLocText : iosLocText,
                  colorBlack,
                  TextAlign.justify,
                  _buildEnableButton(context),
                );
              }
              if (state is VoucherOutletLocationDisabled) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
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
          VoucherDescView(changeView: changePage, title: title),
        ]),
      ),
    );
  }

  Widget _buildEnableButton(BuildContext context) {
    return OderStyleButton(
      title: 'Continue',
      backgroundColor: mainColor,
      onPressed: () async {
        BlocProvider.of<VoucherBloc>(
          context,
        ).add(VoucherOutletLocationEnable());
        Navigator.pop(context);
      },
    );
  }
}
