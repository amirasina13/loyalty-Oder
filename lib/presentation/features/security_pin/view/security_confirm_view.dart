import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../widgets/widgets.dart';
import '../../rewards/reward.dart';
import '../../voucher/voucher.dart';
import '../security_pin.dart';

class SecurityConfirmView extends StatefulWidget {
  final Function changeView;
  const SecurityConfirmView({super.key, required this.changeView});

  @override
  State<SecurityConfirmView> createState() => _SecurityConfirmViewState();
}

class _SecurityConfirmViewState extends State<SecurityConfirmView> {
  bool isProcessing = false;
  String enteredPin = '';

  /// this widget will be use for each digit
  Widget numButton(int number) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3),
        margin: EdgeInsets.symmetric(horizontal: 3),
        child: TextButton(
          onPressed: () {
            setState(() {
              if (enteredPin.length < 6) {
                enteredPin += number.toString();
              }
            });
          },
          style: TextButton.styleFrom(backgroundColor: colorWhite),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: colorBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<SecurityBloc, SecurityState>(
        listener: (context, state) {
          if (state is SecurityPinCreated) {
            setProcessingStatus(false);
            SuccessTimerDialog.showSuccessTimerDialog(
              context,
              state.data['message'],
              () {
                if (Storage().page == 'reward_details') {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.rewardDetails,
                    (Route<dynamic> route) => false,
                    arguments: RewardDetailsParameters(
                      rewardId: Storage().rewardId,
                      title: Storage().titlePasscodeRoute!,
                      indexPage: 3,
                    ),
                  );
                } else if (Storage().page == 'voucher_details') {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.voucherDesc,
                    (Route<dynamic> route) => false,
                    arguments: VoucherDescParameters(
                      voucherId: Storage().voucherId,
                      title: Storage().titlePasscodeRoute!,
                    ),
                  );
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    OderRoutes.wallet,
                    (Route<dynamic> route) => false,
                  );
                }
              },
            );
          }

          if (state is SecurityError) {
            setProcessingStatus(false);
            enteredPin = '';
            showErrorToast(state.error, context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: colorWhite,
            body: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(
                      marginHorizontal,
                      5,
                      marginHorizontal,
                      0,
                    ),
                    // padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                    // height: height / 7,
                    child: Text(
                      Storage().set == 'reset'
                          ? 'Confirm New Passcode'
                          : 'Confirm Passcode',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 10,
                      top: ScreenSize.height / 7.2,
                    ),
                    padding: EdgeInsets.fromLTRB(
                      marginHorizontal,
                      20,
                      marginHorizontal,
                      0,
                    ),
                    child: Text(
                      'Enter Confirm Passcode',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colorBlack,
                        fontFamily: fontFamilyMain,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      marginHorizontal,
                      20,
                      marginHorizontal,
                      0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          // padding: EdgeInsets.all(15),
                          margin: const EdgeInsets.all(10.0),
                          // width: isPinVisible ? 50 : 16,
                          // height: isPinVisible ? 50 : 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colorGreyBox),
                            // borderRadius: BorderRadius.circular(6.0),
                            // color: index < enteredPin.length ? colorBlack : colorWhite,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(13),
                            margin: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // border: Border.all(color: colorGreyBox),
                              // borderRadius: BorderRadius.circular(6.0),
                              color:
                                  index < enteredPin.length
                                      ? colorBlackTab
                                      : colorWhite,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      marginHorizontal,
                      50,
                      marginHorizontal,
                      0,
                    ),
                    margin: EdgeInsets.only(bottom: 20),
                    child: OderStyleButton(
                      title: 'Continue',
                      iconLeading: false,
                      icon: Icons.arrow_forward,
                      onPressed:
                          isProcessing
                              ? () {}
                              : () {
                                _validateAndSend();
                              },
                      backgroundColor:
                          isProcessing ? processing : colorBlackTab,
                      textColor: isProcessing ? processingText : colorWhite,
                      // onPressed: () {
                      //   _validateAndSend();
                      // },
                      // backgroundColor: mainColor,
                    ),
                  ),
                ],
              ),
              // ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    color: colorGreyBox,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                          List.generate(
                            3,
                            (index) => numButton(1 + 3 * i + index),
                          ).toList(),
                    ),
                  ),

                /// 0 digit with back remove
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: colorGreyBox,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // TextButton(onPressed: null, child: SizedBox()),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          margin: EdgeInsets.symmetric(horizontal: 3),
                        ),
                      ),
                      numButton(0),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                if (enteredPin.isNotEmpty) {
                                  enteredPin = enteredPin.substring(
                                    0,
                                    enteredPin.length - 1,
                                  );
                                }
                              });
                            },
                            // style: TextButton.styleFrom(
                            //   backgroundColor: colorWhite,
                            // ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.backspace,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (enteredPin.isEmpty) {
      setProcessingStatus(false);
      showErrorToast('Passcode are required!', context);
    } else if (enteredPin.length < 6) {
      setProcessingStatus(false);
      showErrorToast('Passcode must be 6 digit', context);
    } else if (enteredPin != Storage().securityPin) {
      setProcessingStatus(false);
      showErrorToast('Passcode not match!', context);
      enteredPin = '';
    } else {
      setProcessingStatus(true);
      // Storage().securityPin = enteredPin;
      // widget.changeView(changeType: ViewChangeType.Forward);
      BlocProvider.of<SecurityBloc>(
        context,
      ).add(SecurityCreatePin(pin: enteredPin));
      // print('ENTERED PIN: $enteredPin');
    }
  }
}
