import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../security_pin/security_pin.dart';
import '../../voucher/voucher.dart';
import '../../webview/webview_deeplink.dart';
import '../reward.dart';

class RewardConfirm extends StatefulWidget {
  final Function changeView;
  final Details voucherInfo;
  final String? either;

  // ignore: use_key_in_widget_constructors
  const RewardConfirm({
    Key? key,
    required this.changeView,
    required this.voucherInfo,
    this.either,
  }) : super();

  @override
  State<RewardConfirm> createState() => _RewardConfirmState();
}

class _RewardConfirmState extends State<RewardConfirm> {
  int _itemCount = 1;
  bool isMax = false, isMin = false;
  bool isProcessing = false;
  bool checkValueRead = false;
  String passcodePin = '',
      creditsAmount = '',
      pointsAmount = '',
      totalText = '',
      redeemVia = '',
      refCode = '';
  late FocusNode referralFocus;
  TextEditingController referralController = TextEditingController();
  final GlobalKey<OderInputFieldState> referralKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    referralFocus = FocusNode();
    totalPayment();
    refCode = TempData.voucherRefCode;
  }

  @override
  void dispose() {
    // // Clean up the focus node when the Form is disposed.
    referralFocus.dispose();

    super.dispose();
  }

  totalPayment() {
    if (widget.voucherInfo.voucherType! == 'downloadable') {
      creditsAmount = '0.00';
      pointsAmount = '0.00';
      totalText = '0.00';
    } else if (widget.voucherInfo.purchaseMethod! == 'credits') {
      creditsAmount = widget.voucherInfo.aftDisCredits!;
      pointsAmount = '0.00';
      redeemVia = 'credits';
      totalText =
          creditLabelAlign == 'left'
              ? '$creditLabelText ${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)}'
              : '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} $creditLabelText ';
    } else if (widget.voucherInfo.purchaseMethod! == 'points') {
      creditsAmount = '0.00';
      pointsAmount = widget.voucherInfo.aftDisPoints!;
      redeemVia = 'points';
      totalText =
          pointLabelAlign == 'left'
              ? '$pointLabelText ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)}'
              : '${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} $pointLabelText ';
    } else if (widget.voucherInfo.purchaseMethod! == 'both') {
      creditsAmount = widget.voucherInfo.aftDisCredits!;
      pointsAmount = widget.voucherInfo.aftDisPoints!;
      redeemVia = 'credits';
      totalText =
          creditLabelAlign == 'left' && pointLabelAlign == 'left'
              ? '$creditLabelText ${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} + $pointLabelText ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)}'
              : creditLabelAlign == 'right' && pointLabelAlign == 'right'
              ? '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} $creditLabelText + ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} $pointLabelText '
              : creditLabelAlign == 'left' && pointLabelAlign == 'right'
              ? '$creditLabelText ${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} + ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} $pointLabelText '
              : '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} $creditLabelText + $pointLabelText ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} ';
    } else if (widget.either == 'credits') {
      creditsAmount = widget.voucherInfo.aftDisCredits!;
      pointsAmount = '0.00';
      redeemVia = 'credits';
      totalText =
          creditLabelAlign == 'left'
              ? '$creditLabelText ${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)}'
              : '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} $creditLabelText ';
    } else if (widget.either == 'points') {
      creditsAmount = '0.00';
      pointsAmount = widget.voucherInfo.aftDisPoints!;
      redeemVia = 'points';
      totalText =
          pointLabelAlign == 'left'
              ? '$pointLabelText ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)}'
              : '${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} $pointLabelText ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: Container(
          height: ScreenSize.height * 0.78,
          margin: EdgeInsets.fromLTRB(
            marginHorizontal,
            10,
            marginHorizontal,
            10,
          ),
          child: BlocConsumer<RewardBloc, RewardState>(
            listener: (context, state) {
              /* --------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
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

              if (state is RewardDownloadSuccess) {
                setProcessingStatus(false);
                showSuccessToast(state.data['message'], context);

                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.voucher,
                  (route) => false,
                  arguments: VoucherParameters(
                    selectedTab: 1,
                    filterBy: 'all',
                    filterValue: '1',
                  ),
                );
              }

              if (state is RewardPurchaseSuccess) {
                setProcessingStatus(false);
                showSuccessToast(state.data['message'], context);

                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.voucher,
                  (route) => false,
                  arguments: VoucherParameters(
                    selectedTab: 1,
                    filterBy: 'all',
                    filterValue: '1',
                  ),
                );
              }

              if (state is RewardRedeemFailed) {
                setProcessingStatus(false);
                showErrorToast(state.redeemResponse['message'], context);
                // Navigator.pop(context);
                BlocProvider.of<RewardBloc>(
                  context,
                ).add(RewardDetailsLoad(rewardId: Storage().rewardId));
              }

              if (state is RewardSessionError) {
                sessionExpiredLogOut(state.error);
              }
              if (state is RewardError) {
                setProcessingStatus(false);
                showErrorToast(state.error, context);
              }
              if (state is RewardNetworkError) {
                showErrorToast('No internet connection', context);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.home,
                  (Route<dynamic> route) => false,
                );
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    // alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Payment Details',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Divider(color: colorUsedGray),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      children: [
                        Container(
                          width: ScreenSize.height * 0.04,
                          height: ScreenSize.height * 0.04,
                          margin: EdgeInsets.only(right: 10),
                          padding: EdgeInsets.all(3),
                          // decoration: BoxDecoration(
                          //     color: colorBoxGreen,
                          //     borderRadius: BorderRadius.circular(5)),
                          child: Image(
                            image: AssetImage('assets/icons/coupon.webp'),
                            color: colorGoldButton,
                          ),
                        ),
                        SizedBox(
                          width: ScreenSize.width * 0.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 3),
                                child: Text(
                                  widget.voucherInfo.name!,
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Text(
                                  widget.voucherInfo.desc!,
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              (widget.voucherInfo.redeem! -
                                              int.parse(
                                                widget.voucherInfo.totalOwned!,
                                              )) ==
                                          1 ||
                                      (widget.voucherInfo.redeem! -
                                              int.parse(
                                                widget.voucherInfo.totalOwned!,
                                              )) ==
                                          0
                                  ? SizedBox(
                                    width: ScreenSize.width * 0.09,
                                    child: Text(
                                      _itemCount.toString(),
                                      style: TextStyle(
                                        fontFamily: fontFamilyMain,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                  : Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _itemCount != 0
                                          ? InkWell(
                                            child: Container(
                                              // color: colorButtonLightGrey,
                                              width: ScreenSize.width * 0.07,
                                              height: ScreenSize.width * 0.07,
                                              decoration: BoxDecoration(
                                                color:
                                                    _itemCount != 1
                                                        ? colorMulberry
                                                        : colorButtonLightGrey,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: ScreenSize.width * 0.06,
                                                color:
                                                    _itemCount != 1
                                                        ? colorWhite
                                                        : colorBlack,
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                if (_itemCount > 1) {
                                                  _itemCount--;
                                                  totalPayment();
                                                }
                                              });
                                              // setState(() => _itemCount--);
                                            },
                                          )
                                          : Container(),
                                      SizedBox(
                                        width: ScreenSize.width * 0.09,
                                        child: Text(
                                          _itemCount.toString(),
                                          style: TextStyle(
                                            fontFamily: fontFamilyMain,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                          width: ScreenSize.width * 0.07,
                                          height: ScreenSize.width * 0.07,
                                          decoration: BoxDecoration(
                                            color:
                                                _itemCount >=
                                                        widget
                                                                .voucherInfo
                                                                .redeem! -
                                                            int.parse(
                                                              widget
                                                                  .voucherInfo
                                                                  .totalOwned!,
                                                            )
                                                    ? colorButtonLightGrey
                                                    : colorMulberry,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: ScreenSize.width * 0.06,
                                            color:
                                                _itemCount >=
                                                        widget
                                                                .voucherInfo
                                                                .redeem! -
                                                            int.parse(
                                                              widget
                                                                  .voucherInfo
                                                                  .totalOwned!,
                                                            )
                                                    ? colorBlack
                                                    : colorWhite,
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            if (_itemCount <
                                                widget.voucherInfo.redeem! -
                                                    int.parse(
                                                      widget
                                                          .voucherInfo
                                                          .totalOwned!,
                                                    )) {
                                              _itemCount++;
                                              totalPayment();
                                            }
                                          });
                                          // setState(() => _itemCount++);
                                        },
                                      ),
                                    ],
                                  ),
                              (widget.voucherInfo.redeem! -
                                              int.parse(
                                                widget.voucherInfo.totalOwned!,
                                              )) ==
                                          1 ||
                                      (widget.voucherInfo.redeem! -
                                              int.parse(
                                                widget.voucherInfo.totalOwned!,
                                              )) ==
                                          0
                                  ? Container()
                                  : Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Text(
                                      '${widget.voucherInfo.redeem! - int.parse(widget.voucherInfo.totalOwned!)} left',
                                      style: TextStyle(
                                        fontFamily: fontFamilyMain,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: colorReferGrey,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: colorUsedGray),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          creditLabelTitle,
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorReferGrey,
                          ),
                        ),
                        Text(
                          creditLabelAlign == 'left'
                              ? '$creditLabelText $creditsAmount'
                              : '$creditsAmount $creditLabelText',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colorReferGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Point(s)',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorReferGrey,
                          ),
                        ),
                        Text(
                          pointLabelAlign == 'left'
                              ? '$pointLabelText $pointsAmount'
                              : '$pointsAmount $pointLabelText',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colorReferGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorReferGrey,
                          ),
                        ),
                        Text(
                          '$_itemCount',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colorReferGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total to pay',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: mainColor,
                          ),
                        ),
                        Text(
                          totalText,
                          // widget.voucherInfo.purchaseMethod! == 'both'
                          //     ? '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} Credit(s) + ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} Point(s)'
                          //     : creditsAmount != '0.00'
                          //         ? (double.parse(creditsAmount) *
                          //                 _itemCount)
                          //             .toStringAsFixed(2)
                          //         : pointsAmount != '0.00'
                          //             ? (double.parse(pointsAmount) *
                          //                     _itemCount)
                          //                 .toStringAsFixed(2)
                          //             : '0.00',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colorBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            'Referral Code',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colorReferGrey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // height: height * 0.05,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color:
                                  refCode.isNotEmpty
                                      ? Colors.grey[200]
                                      : colorBackground,
                              border: Border.all(color: colorGreyBox),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextField(
                              readOnly: refCode.isNotEmpty ? true : false,
                              controller: referralController,
                              style: TextStyle(
                                fontFamily: fontFamilyMain,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colorBlack,
                              ),
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: refCode.isNotEmpty ? refCode : '',
                                hintStyle: TextStyle(
                                  color:
                                      refCode.isNotEmpty
                                          ? colorBlack
                                          : colorSoftGrey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: fontFamilyMain,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            // height: sizeBetween * 0.97,
                            child: Theme(
                              data: ThemeData(
                                // unselectedWidgetColor: Colors.black45,
                                checkboxTheme: CheckboxThemeData(
                                  // For every Material state we return the same border style
                                  side: WidgetStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                      color:
                                          checkValueRead == false
                                              ? Colors.black45
                                              : colorGoldButton,
                                    ),
                                  ),
                                ),
                              ),
                              child: CheckboxListTile(
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0,
                                ),
                                title: OderRichText(
                                  oneText:
                                      'I have read, understood and accept the ',
                                  twoText: 'Terms & Conditions ',
                                  title1: 'Terms & Conditions',
                                  url1: urlTerm,
                                  threeText: 'and ',
                                  fourText: 'Privacy Policy.',
                                  title2: 'Privacy Policy',
                                  url2: urlPolicy,
                                ),
                                value: checkValueRead,
                                onChanged: _onChangedRead,
                                checkColor: colorWhite,
                                activeColor: colorGoldButton,
                              ),
                            ),
                          ),
                          BlocConsumer<SecurityBloc, SecurityState>(
                            listener: (context, securityState) {
                              // setProcessingStatus(false);

                              if (securityState is SecurityCheckVerified) {
                                if (securityState.verified == false) {
                                  setProcessingStatus(false);

                                  Storage().page = 'reward_details';
                                  Navigator.of(
                                    context,
                                  ).pushNamed(OderRoutes.securityCreate);

                                  // Navigator.of(context).pushNamed(
                                  //      OderRoutes.securityRegister);
                                } else {
                                  Storage().page = 'reward_details';
                                  Navigator.of(
                                    context,
                                  ).pushNamed(OderRoutes.passcodeKey).then((
                                    value,
                                  ) {
                                    if (value != null) {
                                      passcodePin = value.toString();

                                      setState(() {
                                        if (widget.voucherInfo.voucherType ==
                                            'downloadable') {
                                          BlocProvider.of<RewardBloc>(
                                            context,
                                          ).add(
                                            RewardDownload(
                                              voucherId: widget.voucherInfo.id!,
                                              pin: passcodePin,
                                              referral:
                                                  referralController
                                                          .text
                                                          .isNotEmpty
                                                      ? referralController.text
                                                      : refCode,
                                              quantity: _itemCount.toString(),
                                            ),
                                          );
                                        } else {
                                          BlocProvider.of<RewardBloc>(
                                            context,
                                          ).add(
                                            RewardPurchaseLoad(
                                              voucherId: widget.voucherInfo.id!,
                                              redeemVia: redeemVia,
                                              points: '0.00',
                                              pin: passcodePin,
                                              referral:
                                                  referralController
                                                          .text
                                                          .isNotEmpty
                                                      ? referralController.text
                                                      : refCode,
                                              quantity: _itemCount.toString(),
                                            ),
                                          );
                                        }
                                      });
                                    } else {
                                      setProcessingStatus(false);
                                    }
                                  });
                                }
                              }

                              if (securityState is SecurityOtpSent) {
                                showSuccessToast(
                                  securityState.data['message'],
                                  context,
                                );
                                Navigator.of(context).pushNamed(
                                  OderRoutes.securityOtp,
                                  arguments: SecurityOtpParameters(
                                    otpData: securityState.data,
                                  ),
                                );
                              }

                              if (securityState is SecurityError) {
                                Navigator.pop(context);
                                showErrorToast(securityState.error, context);
                              }
                              /* ----------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
                              if (securityState is SecurityMaintenanceError) {
                                Navigator.pushAndRemoveUntil<void>(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder:
                                        (BuildContext context) =>
                                            MaintenanceScreen(
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
                              return OderStyleButton(
                                height: ScreenSize.height / 14,
                                title:
                                    isProcessing ? 'Processing...' : 'Pay Now',
                                iconLeading: false,
                                // icon: Icons.arrow_forward,
                                backgroundColor:
                                    isProcessing ? processing : colorMulberry,
                                textColor:
                                    isProcessing ? processingText : colorWhite,
                                onPressed: _validateAndSend,
                              );
                            },
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              // color: colorBabyBlue,
                              alignment: Alignment.center,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _onChangedRead(bool? value) {
    if (value != null) {
      setState(() {
        checkValueRead = value;
      });
    }
  }

  void _validateAndSend() {
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    fToast.removeCustomToast();

    if (checkValueRead == false) {
      // errorfield = '';
      showErrorToast(
        'To continue, kindly read and agree to the Terms & Conditions.',
        context,
      );
    } else {
      BlocProvider.of<SecurityBloc>(context).add(SecurityStart());
    }
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
