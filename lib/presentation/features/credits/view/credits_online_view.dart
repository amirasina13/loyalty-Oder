import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../profile/profile.dart';
import '../../security_pin/security_pin.dart';
import '../credits.dart';

class CreditOnlineView extends StatefulWidget {
  final Function? changeView;

  const CreditOnlineView({super.key, this.changeView});

  @override
  State<CreditOnlineView> createState() => _CreditOnlineViewState();
}

class _CreditOnlineViewState extends State<CreditOnlineView> {
  List<RadioModel> amountOptions = [];
  String selectedAmount = '';
  String errorfield = '';

  TextEditingController amountController = TextEditingController();
  final GlobalKey<OderInputFieldState> amountKey = GlobalKey();
  final TextEditingController pinController = TextEditingController();
  late FocusNode amountFocus;
  bool isProcessing = false;
  bool load = false;
  bool rebutton = false;
  SliderButtonController slideController = SliderButtonController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    margin: EdgeInsets.zero,
  );

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    /* ------------------------------------------------------------------------- Add amount in amountOptions list from API */
    for (var amount in creditSelection) {
      amountOptions.add(
        RadioModel(false, amount),
      ); //adding each value to the list
    }

    amountFocus = FocusNode();

    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    amountFocus.dispose();
    slideController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreditBloc, CreditState>(
      // bloc: CreditBloc,
      listener: (context, creditState) {
        /* --------------------------------------------------------------------- If user click "Reload Now" button, will open topup webview */
        if (creditState is CreditOnlineLoaded) {
          setProcessingStatus(false);
          Navigator.push(
            context,
            NoAnimationPageRoute(
              builder: (context) {
                // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                return WidgetWebView(
                  widgetUrl: creditState.url,
                  title: 'Top Up Wallet',
                );
              },
            ),
          ).then(
            (value) => Timer(Duration(milliseconds: 5), () {
              // slideController.removeListener(() {
              //   //   return slideController.reset();
              // });
              slideController.reset();
              BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
              // slideController.dispose();
            }),
          );
          // Navigator.push(
          //   context,
          //   NoAnimationPageRoute(
          //     builder: (context) {
          //       return Scaffold(
          //         appBar: AppBar(
          //           systemOverlayStyle: SystemUiOverlayStyle(
          //             statusBarColor: colorBackground,
          //             systemNavigationBarColor: colorWhite,
          //           ),
          //           title: Text(
          //             'Top Up Wallet',
          //             style: TextStyle(
          //               fontFamily: fontFamilyMain,
          //               color: colorBlack,
          //               fontWeight: FontWeight.w400,
          //               fontSize: 15,
          //             ),
          //             textScaler: TextScaler.linear(scaleFactor),
          //           ),
          //           leading: IconButton(
          //             icon: Icon(Icons.close),
          //             onPressed: () {
          //               Navigator.pop(context);
          //             },
          //           ),
          //           centerTitle: true,
          //           backgroundColor: colorWhite,
          //           iconTheme: IconThemeData(color: colorBlack),
          //           elevation: 0,
          //         ),
          //         // body: TopupWebView(paymentUrl: creditState.url),
          //         body: WidgetWebView(widgetUrl: creditState.url),
          //       );
          //     },
          //   ),
          // ).then(
          //   (value) => Timer(Duration(milliseconds: 5), () {
          //     // slideController.removeListener(() {
          //     //   //   return slideController.reset();
          //     // });
          //     slideController.reset();
          //     BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
          //     // slideController.dispose();
          //   }),
          // );
        }

        if (creditState is CreditError) {
          setProcessingStatus(false);
          // setState(() {
          // print('RESET!!');
          Timer(Duration(milliseconds: 5), () {
            // slideController.removeListener(() {
            //   //   return slideController.reset();
            // });
            slideController.reset();
            // slideController.dispose();
          });
          // rebutton = false;
          // slideController.dispose();

          // BlocProvider.of<ProfileBloc>(context)
          //   ..reloadBack = true
          //   ..add(ProfileLoad());
          // });

          // setState(() {
          //   BlocProvider.of<ProfileBloc>(context)
          //     ..reloadBack = true
          //     ..add(ProfileLoad());
          // });

          showErrorToast(creditState.error, context);
        }
        if (creditState is CreditNetworkError) {
          showErrorToast(creditState.error, context);
        }
        if (creditState is CreditSessionError) {
          sessionExpiredLogOut(creditState.error);
        }
      },

      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, profileState) {},
        builder: (context, profileState) {
          if (profileState is ProfileReloading) {
            return Container(
              // height: height * 0.7,
              color: colorBackground,
              child: LoadingWidget(),
            );
          }

          return Container(
            color: colorBackground,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    color: colorRedDark,
                    padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            'Balance',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: fontFamilyMain,
                              fontWeight: FontWeight.w600,
                              color: colorWhite,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 30),
                          child: Text(
                            creditLabelAlign == 'left'
                                ? '$creditLabelText ${profileState is ProfileLoaded ? double.parse(profileState.userProfile.profile!.credits ?? '0').toStringAsFixed(2) : '0.00'}'
                                : '${profileState is ProfileLoaded ? double.parse(profileState.userProfile.profile!.credits ?? '0').toStringAsFixed(2) : '0.00'} $creditLabelText ',
                            style: TextStyle(
                              fontSize: 32,
                              fontFamily: fontFamilyMain,
                              fontWeight: FontWeight.w600,
                              color: colorWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      /* ----------------------------------------------------------- Input reload part */
                      Container(
                        // margin: EdgeInsets.only(top: 40),
                        margin: EdgeInsets.fromLTRB(
                          marginHorizontal,
                          20,
                          marginHorizontal,
                          0,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Set Amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyMain,
                            fontWeight: FontWeight.w600,
                            color: colorBlack,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(
                          marginHorizontal,
                          5,
                          marginHorizontal,
                          0,
                        ),
                        child: Text(
                          'How much would you like to top up?',
                          style: TextStyle(
                            color: colorBlack,
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      /* Input field part */
                      Theme(
                        data: ThemeData(
                          primaryColor: colorBlack,
                          textSelectionTheme: TextSelectionThemeData(
                            cursorColor:
                                errorfield == '' ? colorUsedGray : colorRed,
                            selectionHandleColor: colorMulberry,
                          ),
                        ),
                        child: Container(
                          // margin: EdgeInsets.only(top: 0, bottom: 10),
                          margin: EdgeInsets.fromLTRB(
                            marginHorizontal,
                            30,
                            marginHorizontal,
                            10,
                          ),
                          alignment: Alignment.center,
                          height: ScreenSize.height / 16,
                          child: TextField(
                            key: amountKey,
                            controller: amountController,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              CurrencyTextInputFormatter.currency(symbol: ''),
                              // DecimalTextInputFormatter(decimalRange: 2)
                              // CurrencyTextInputFormatter(symbol: ''),
                              // CurrencyTextInputFormatter(
                              //     // locale: 'ko',
                              //     // decimalDigits: 0,
                              //     // symbol: '',
                              //     ),
                            ],
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                              hintText: '0.00',
                              hintStyle: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                fontFamily: fontFamilyMain,
                                color: colorTopupGrey,
                              ),
                              isDense: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      errorfield == '' ? colorGrey : colorRed,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: errorfield == '' ? mainColor : colorRed,
                              fontFamily: fontFamilyMain,
                            ),
                            textAlignVertical: TextAlignVertical.center,
                            focusNode: amountFocus,
                            onChanged: (value) {
                              if (value != '') {
                                setState(() {
                                  errorfield = '';
                                  amountKey.currentState?.validate();

                                  if (selectedAmount != amountController.text) {
                                    for (var element in amountOptions) {
                                      element.isSelected = false;
                                    }
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      /* ----------------------------------------------------------- List of amountOptions part */
                      Container(
                        height: ScreenSize.height * 0.2,
                        // margin: EdgeInsets.symmetric(vertical: 10),
                        margin: EdgeInsets.fromLTRB(
                          marginHorizontal,
                          10,
                          marginHorizontal,
                          10,
                        ),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 4,
                          childAspectRatio: (50 / 25),
                          children: List.generate(amountOptions.length, (
                            index,
                          ) {
                            return InkWell(
                              splashColor: colorGoldButton,
                              onTap: () {
                                setState(() {
                                  for (var element in amountOptions) {
                                    element.isSelected = false;
                                  }
                                  amountOptions[index].isSelected = true;
                                  selectedAmount =
                                      amountOptions[index].buttonText;
                                  amountController.text =
                                      amountOptions[index].buttonText;
                                });
                              },
                              child: OderRadioSelect(amountOptions[index]),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
                /* ----------------------------------------------------------------- Reload Now button part */
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: BlocConsumer<SecurityBloc, SecurityState>(
                    listener: (context, securityState) {
                      fToast = FToast();
                      fToast.init(context);
                      if (securityState is SecurityCheckVerified) {
                        setProcessingStatus(false);

                        if (securityState.verified == false) {
                          Storage().page = 'credits';
                          Navigator.of(
                            context,
                          ).pushNamed(OderRoutes.securityCreate).then((value) {
                            setProcessingStatus(false);

                            Timer(Duration(milliseconds: 5), () {
                              slideController.reset();
                            });
                          });
                        } else {
                          Storage().page = 'wallet';
                          Navigator.of(
                            context,
                          ).pushNamed(OderRoutes.passcodeKey).then((value) {
                            if (value != null) {
                              // passcodePin = value.toString();

                              // print('VALUEPIN: $vaslue');

                              setState(() {
                                _validateAndSend();

                                //
                                // BlocProvider.of<RewardBloc>(context)
                                //     .add(RewardPurchaseLoad(
                                //   voucherId: detail.voucher!.id!,
                                //   pin: passcodePin,
                                // ));
                              });
                            } else {
                              setProcessingStatus(false);

                              Timer(Duration(milliseconds: 5), () {
                                slideController.reset();
                              });
                            }
                          });
                        }
                      }

                      if (securityState is SecurityPinVerified) {
                        _validateAndSend();
                      }

                      if (securityState is SecurityError) {
                        setProcessingStatus(false);
                        showErrorToast(securityState.error, context);
                      }

                      /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
                      if (securityState is SecurityMaintenanceError) {
                        Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder:
                                (BuildContext context) => MaintenanceScreen(
                                  parameters: MaintenanceParameters(
                                    message: securityState.message,
                                  ),
                                ),
                          ),
                          ModalRoute.withName('/'),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Container(
                        alignment: Alignment.bottomCenter,
                        // margin: EdgeInsets.only(bottom: 10),
                        height: ScreenSize.height * 0.12,
                        margin: EdgeInsets.fromLTRB(
                          marginHorizontal,
                          10,
                          marginHorizontal,
                          10,
                        ),
                        child: SlideButton(
                          controller: slideController,
                          textButton: Text(
                            'Slide to top up',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              // letterSpacing: 2,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colorBlack,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          textSlide: Text(
                            'Top Up',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              letterSpacing: 2,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorWhite,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // buttonSize: height / 14,
                          backgroundColor: colorWhiteSlider,
                          slideColor: colorGoldButton,
                          icon: Icon(Icons.arrow_forward, color: colorWhite),
                          // buttonColor: colorSlideGreen,
                          onSlided: () async {
                            // redeemMethod = 1;

                            _checkVerified();

                            // return rebutton;

                            // return true;
                          },
                        ),
                        // child:  OderStyleButton(
                        //   title: isProcessing ? 'Processing...' : 'Reload Now',
                        //   backgroundColor: isProcessing ? processing : mainColor,
                        //   textColor: isProcessing ? processingText : colorWhite,
                        //   height: height / 14,
                        //   onPressed: () =>
                        //       _checkVerified(), //_validateAndSend(context),
                        // ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _checkVerified() {
    if (amountController.text.isEmpty) {
      setProcessingStatus(false);
      errorfield = 'errorAmount';
      showErrorToast('Amount field cannot be empty', context);

      Timer(Duration(seconds: 1), () {
        slideController.reset();
      });
    } else {
      setProcessingStatus(true);
      FocusScope.of(context).unfocus();

      // rebutton = true;

      BlocProvider.of<SecurityBloc>(context).add(SecurityStart());
    }
  }

  // void _validateSecurityPin() {
  //   if (pinController.text == '') {
  //     showErrorToast('Security pin are required!', context);
  //   } else {
  //     FutureOr.delayed(Duration(seconds: 1), () {
  //       load = false;
  //       BlocProvider.of<SecurityBloc>(context).add(SecurityPinVerify(
  //         pin: pinController.text,
  //       ));
  //       Navigator.pop(context);
  //     });
  //   }
  // }

  void _validateAndSend() {
    fToast = FToast();
    fToast.init(context);

    String topupAmount = amountController.text.replaceAll(RegExp("[,]"), "");

    setProcessingStatus(true);
    BlocProvider.of<CreditBloc>(
      context,
    ).add(CreditOnlineLoad(amount: topupAmount.trim()));
  }

  void sessionExpiredLogOut(String error) {
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    showErrorToast('$error\nYou will be logged out.', context);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.login,
      (Route<dynamic> route) => false,
    );
  }
}
