import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../widgets/widgets.dart';

class SecuritySetView extends StatefulWidget {
  final Function changeView;
  const SecuritySetView({super.key, required this.changeView});

  @override
  State<SecuritySetView> createState() => _SecuritySetViewState();
}

class _SecuritySetViewState extends State<SecuritySetView> {
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
      child: Scaffold(
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
                  50,
                  marginHorizontal,
                  0,
                ),
                // padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                height: ScreenSize.height / 7,
                child: Text(
                  Storage().set == 'reset'
                      ? 'Set New Passcode'
                      : 'Set Passcode',
                  style: TextStyle(
                    fontFamily: fontFamilyMain,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, top: ScreenSize.height / 8),
                padding: EdgeInsets.fromLTRB(
                  marginHorizontal,
                  20,
                  marginHorizontal,
                  0,
                ),
                child: Text(
                  'Enter Passcode',
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
                  onPressed: () {
                    _validateAndSend();
                    // widget.changeView(changeType: ViewChangeType.Forward);
                  },
                  backgroundColor: colorBlackTab,
                ),
              ),
            ],
          ),
          // ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
    } else {
      // setProcessingStatus(true);
      Storage().securityPin = enteredPin;
      Navigator.of(context).pushNamed(OderRoutes.securityConfirm);
      // BlocProvider.of<SecurityBloc>(context).add(
      //   SecurityCreatePin(
      //     pin: confirmPinController.text,
      //   ),
      // );
      // print('ENTERED PIN: $enteredPin');
    }
  }
}
