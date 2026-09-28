import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../widgets/widgets.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../profile/profile.dart';
import '../security_pin.dart';

class SecurityPhoneView extends StatefulWidget {
  final Function changeView;
  const SecurityPhoneView({super.key, required this.changeView});

  @override
  State<SecurityPhoneView> createState() => _SecurityPhoneViewState();
}

class _SecurityPhoneViewState extends State<SecurityPhoneView> {
  bool isProcessing = false;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SecurityBloc, SecurityState>(
      listener: (context, state) {
        fToast = FToast();
        fToast.init(context);

        // if (state is SecurityOtpSent) {
        //   showSuccessToast(state.data['message'], context);
        //   Navigator.of(context).pushNamed( OderRoutes.securityOtp);

        // }

        if (state is SecurityOtpSent) {
          // setProcessingStatus(false);
          // setResetProcessingStatus(false);
          showSuccessToast(state.data['message'], context);

          Navigator.of(context).pushNamed(
            OderRoutes.securityOtp,
            arguments: SecurityOtpParameters(otpData: state.data),
          );
        }

        /* --------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
        if (state is SecurityMaintenanceError) {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
              builder:
                  (BuildContext context) => MaintenanceScreen(
                    parameters: MaintenanceParameters(message: state.message),
                  ),
            ),
            ModalRoute.withName('/'),
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              OderRoutes.wallet,
              (Route<dynamic> route) => false,
            );
          },
          child: Scaffold(
            backgroundColor: colorWhite,
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
              child: SingleChildScrollView(
                child: Container(
                  // height: height * 0.8,
                  color: colorWhite,
                  child: Column(
                    children: [
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileLoaded) {
                            // String phone = state.userProfile.profile!.contact!;
                            // int numSpace = phone.length - 7;
                            // String result = phone.replaceRange(
                            //     5, phone.length - 2, '*' * numSpace);

                            return Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(
                                    marginHorizontal,
                                    50,
                                    marginHorizontal,
                                    0,
                                  ),
                                  // padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                                  height: ScreenSize.height / 7,
                                  child: Text(
                                    'Change Passcode',
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: ScreenSize.height / 10,
                                  width: ScreenSize.width,
                                  color: colorTransparent,
                                  margin: EdgeInsets.symmetric(vertical: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(
                                              ScreenSize.width * 0.3,
                                              ScreenSize.height / 16,
                                            ),
                                            backgroundColor: colorWhite,
                                            elevation: 0,
                                            side: BorderSide(
                                              width: 1,
                                              color: colorPinGrey,
                                            ),
                                          ),
                                          onPressed:
                                              Storage().page == 'wallet'
                                                  ? () {
                                                    Navigator.of(
                                                      context,
                                                    ).pushNamedAndRemoveUntil(
                                                      OderRoutes.wallet,
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    );
                                                  }
                                                  : () {
                                                    Navigator.of(
                                                      context,
                                                    ).pushNamedAndRemoveUntil(
                                                      OderRoutes.setting,
                                                      (Route<dynamic> route) =>
                                                          false,
                                                    );
                                                  },
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: colorBlack,
                                              fontFamily: fontFamilyMain,
                                            ),
                                            textScaler: TextScaler.linear(
                                              scaleFactor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: ScreenSize.width * 0.02),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(
                                              ScreenSize.width * 0.3,
                                              ScreenSize.height / 16,
                                            ),
                                            backgroundColor: colorBlackTab,
                                            elevation: 0,
                                            side: BorderSide(
                                              width: 1,
                                              color: colorBlackTab,
                                            ),
                                          ),
                                          child: Text(
                                            'Yes',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: colorWhite,
                                              fontFamily: fontFamilyMain,
                                            ),
                                            textScaler: TextScaler.linear(
                                              scaleFactor,
                                            ),
                                          ),
                                          onPressed: () {
                                            // Storage().contact = phone;
                                            // Navigator.of(context).pushNamed(
                                            //      OderRoutes.securityOriginal);
                                            BlocProvider.of<SecurityBloc>(
                                              context,
                                            ).add(SecurityOtpSend());
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          return Container(
                            height: ScreenSize.height,
                            color: colorBackground,
                            child: LoadingWidget(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
