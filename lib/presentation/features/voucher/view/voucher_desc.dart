import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../widgets/extensions/location_screen.dart';
import '../../../widgets/widgets.dart';
import '../../maintenance/maintenance.dart';
import '../../security_pin/security_pin.dart';
import '../voucher.dart';

class VoucherDescView extends StatefulWidget {
  final Function? changeView;
  final String? title;

  const VoucherDescView({super.key, this.changeView, this.title});

  @override
  State<VoucherDescView> createState() => _VoucherDescViewState();
}

class _VoucherDescViewState extends State<VoucherDescView> with RouteAware {
  bool isProcessing = false;
  int redeemMethod = 1;
  String passcodePin = '', qrCode = '';
  List<RewardOutlet> vouchersOutlet = [];
  SliderButtonController slideController = SliderButtonController();
  late Timer durationLoading;
  late VoucherDetails detail;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  void setProcessingStatus(bool processing) {
    if (!mounted) return;
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          OderRoutes.voucher,
          (Route<dynamic> route) => false,
          arguments: VoucherParameters(
            selectedTab: 1,
            filterBy: 'all',
            filterValue: '1',
          ),
        );
      },
      child: OderScaffold(
        title: Text(
          widget.title!,
          style: TextStyle(
            fontFamily: fontFamilyMain,
            color: colorBlack,
            fontWeight: FontWeight.w400,
            fontSize: 15,
            // overflow: TextOverflow.ellipsis,
          ),
          textScaler: TextScaler.linear(scaleFactor),
          textAlign: TextAlign.center,
        ),
        appbarAction: [
          InkWell(
            onTap: () async {
              // _onShare method: FOR IPAD
              // final box = context.findRenderObject() as RenderBox?;

              final response = await get(Uri.parse(detail.image!));
              final directory = await getTemporaryDirectory();
              File file = await File(
                '${directory.path}/Image.png',
              ).writeAsBytes(response.bodyBytes);

              if (!context.mounted) return; // Add mounted check
              final box = context.findRenderObject() as RenderBox?;

              if (Platform.isAndroid) {
                await Share.shareXFiles(
                  [XFile(file.path)],
                  text: '${detail.share}\n\n${detail.shareLink}',
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size,
                );
              } else {
                await Share.share(
                  '${detail.share}\n\n${detail.shareLink}',
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size,
                );
              }
            },
            child: Image.asset(
              'assets/icons/share.webp',
              color: colorGreyBox,
              scale: 1.3,
            ),
          ),
        ],
        bottomMenuIndex: 2,
        showBottomNavigator: false,
        body: SafeArea(
          child: Container(
            color: colorBackground,
            child: BlocConsumer<VoucherBloc, VoucherState>(
              listener: (context, state) {
                fToast = FToast();
                fToast.init(context);

                if (state is VoucherOutletStarted) {
                  BlocProvider.of<VoucherBloc>(
                    context,
                  ).add(VoucherDetailsLoad(voucherId: Storage().voucherId));
                }

                if (state is VoucherRedeemSuccess) {
                  VoucherSuccessDialog.showVoucherSuccessDialog(
                    context,
                    state.redeemResponse,
                    () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.voucher,
                        (Route<dynamic> route) => false,
                        arguments: VoucherParameters(
                          selectedTab: 2,
                          filterBy: 'all',
                          filterValue: '1',
                        ),
                      );
                    },
                  );
                }
              },
              builder: (context, state) {
                // if (state is VoucherOutletStarted) {
                //   BlocProvider.of<VoucherBloc>(
                //     context,
                //   ).add(VoucherDetailsLoad(voucherId: Storage().voucherId));
                // }

                if (state is VoucherDetailsLoaded) {
                  detail = state.details;
                  var voucherId = detail.id;
                  var formatter = DateFormat(appDateFormat);
                  var dateFormate = formatter.format(
                    DateTime.parse(detail.expired!),
                  );
                  vouchersOutlet = state.details.outlets!;

                  if (voucherId != null) {
                    return RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: () async {
                        await Future.delayed(Duration(seconds: 1));
                        BlocProvider.of<VoucherBloc>(
                          // ignore: use_build_context_synchronously
                          context,
                        ).add(VoucherOutletCheck());
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: colorBackground,
                              // margin: EdgeInsets.fromLTRB(
                              //     marginHorizontal, 0, marginHorizontal, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(
                                          marginHorizontal,
                                          0,
                                          marginHorizontal,
                                          26,
                                        ),
                                        // padding: EdgeInsets.only(bottom: 26),
                                        child: AspectRatio(
                                          aspectRatio: 1 / 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: colorDisableGrey,
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: colorGreyBox,
                                                  blurRadius: 5.0,
                                                  offset: Offset(0.0, 5.0),
                                                ),
                                              ],
                                            ),
                                            child: CachedImage(
                                              imageUrl: detail.image!,
                                              // colorFilter: ColorFilter.mode(
                                              //   colorWhite.withOpacity(0.35),
                                              //   BlendMode.dstATop,
                                              // ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      detail.isMuslim == true
                                          ? Positioned(
                                            right: 20,
                                            top: 5,
                                            child: HalalWidget(
                                              muslimCategory:
                                                  detail.muslimCategory!,
                                              width: ScreenSize.width * 0.15,
                                            ),
                                          )
                                          : SizedBox(),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      marginHorizontal,
                                      0,
                                      marginHorizontal,
                                      0,
                                    ),
                                    child: Text(
                                      detail.name!,
                                      style: TextStyle(
                                        fontFamily: fontFamilyMain,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: marginHorizontal,
                                      vertical: 20,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: Container(
                                            // height: height * 0.07,
                                            width: ScreenSize.width * 0.35,
                                            padding: EdgeInsets.all(3),
                                            // margin: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              // shape: BoxShape.circle,
                                              color: colorGoldButton,
                                              border: Border.all(
                                                color: colorWhite,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: colorGreyBox,
                                                  blurRadius: 4.0,
                                                  spreadRadius: 2,
                                                  offset: Offset(0.0, 1.0),
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image(
                                                    width:
                                                        ScreenSize.width *
                                                        0.035,
                                                    image: AssetImage(
                                                      'assets/icons/empty_brand.webp',
                                                    ),
                                                    color: colorBlackTab,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        ScreenSize.width * 0.01,
                                                  ),
                                                  Text(
                                                    '${detail.outlets!.length} Outlet(s)',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: mainColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              OderRoutes.locationOutlet,
                                              arguments:
                                                  LocationScreenParameters(
                                                    locationDetails:
                                                        vouchersOutlet,
                                                  ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      marginHorizontal,
                                      0,
                                      marginHorizontal,
                                      10,
                                    ),
                                    // alignment: Alignment.topLeft,
                                    color: colorBackground,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: ScreenSize.height * 0.03,
                                          height: ScreenSize.height * 0.03,
                                          margin: EdgeInsets.only(right: 15),
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: colorWhite,
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            border: Border.all(
                                              color: colorRedDark,
                                            ),
                                          ),
                                          child: Image(
                                            image: AssetImage(
                                              'assets/icons/calendar.webp',
                                            ),
                                            color: colorRedDark,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Valid till',
                                              style: TextStyle(
                                                fontFamily: fontFamilyMain,
                                                fontSize: 11,
                                                color: colorGreyBlue,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textScaler: TextScaler.linear(
                                                scaleFactor,
                                              ),
                                            ),
                                            Text(
                                              dateFormate,
                                              style: TextStyle(
                                                fontFamily: fontFamilyMain,
                                                fontSize: 12,
                                                color: colorBlack,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textScaler: TextScaler.linear(
                                                scaleFactor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: colorDarkGray,
                                    thickness: 0.4,
                                    indent: marginHorizontal,
                                    endIndent: marginHorizontal,
                                  ),
                                  /* --------------------------------------------------- Description title part */
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      marginHorizontal,
                                      10,
                                      marginHorizontal,
                                      10,
                                    ),
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: colorBlack,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textScaler: TextScaler.linear(
                                        scaleFactor,
                                      ),
                                    ),
                                  ),
                                  /* --------------------------------------------------- Description info part(from API) */
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      marginHorizontal,
                                      0,
                                      marginHorizontal,
                                      20,
                                    ),
                                    padding: EdgeInsets.only(left: 20),
                                    alignment: Alignment.topLeft,
                                    color: colorWhite,
                                    child: Text(
                                      detail.desc!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        // color: colorSoftGrey,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textScaler: TextScaler.linear(
                                        scaleFactor,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: colorDarkGray,
                                    thickness: 0.5,
                                    indent: marginHorizontal,
                                    endIndent: marginHorizontal,
                                  ),
                                  /* --------------------------------------------------- Terms & conditions title part */
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      marginHorizontal,
                                      20,
                                      marginHorizontal,
                                      16,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Terms & Conditions:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: colorBlack,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textScaler: TextScaler.linear(
                                        scaleFactor,
                                      ),
                                    ),
                                  ),
                                  /* --------------------------------------------------- Terms & conditions info part(from API) */
                                  Container(
                                    color: colorTransparent,
                                    margin: EdgeInsets.fromLTRB(
                                      marginHorizontal,
                                      0,
                                      marginHorizontal,
                                      20,
                                    ),
                                    child: HtmlWidget(
                                      detail.tnc!,
                                      textStyle: TextStyle(
                                        fontSize: 14,
                                        color: colorBlackTab,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      // customWidgetBuilder: (element) {
                                      //   if (element.localName == 'span') {
                                      //     return Text(
                                      //       element.text,
                                      //       style: TextStyle(
                                      //         fontFamily: fontFamilyMain,
                                      //         fontSize: 14,
                                      //         color: colorSoftGrey,
                                      //       ),
                                      //     );
                                      //   }
                                      //   return null;
                                      // },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(
                                      marginHorizontal,
                                      10,
                                      marginHorizontal,
                                      20,
                                    ),
                                    child: BlocConsumer<
                                      SecurityBloc,
                                      SecurityState
                                    >(
                                      listener: (context, securityState) {
                                        fToast = FToast();
                                        fToast.init(context);

                                        setProcessingStatus(false);

                                        if (securityState
                                            is SecurityCheckVerified) {
                                          if (securityState.verified == false) {
                                            Storage().page = 'voucher_details';
                                            Navigator.of(context)
                                                .pushNamed(
                                                  OderRoutes.securityCreate,
                                                )
                                                .then((value) {
                                                  if (!context.mounted) return;
                                                  BlocProvider.of<VoucherBloc>(
                                                      context,
                                                    )
                                                    ..reloadBack = true
                                                    ..add(
                                                      VoucherDetailsLoad(
                                                        voucherId:
                                                            Storage().voucherId,
                                                      ),
                                                    );

                                                  setProcessingStatus(false);

                                                  Timer(
                                                    Duration(milliseconds: 5),
                                                    () {
                                                      slideController.reset();
                                                    },
                                                  );
                                                });
                                          } else {
                                            Storage().page = 'voucher_details';
                                            redeemMethod == 1
                                                ? Navigator.of(context)
                                                    .pushNamed(
                                                      OderRoutes.passcodeKey,
                                                    )
                                                    .then((value) {
                                                      if (value != null) {
                                                        passcodePin =
                                                            value.toString();

                                                        setState(() {
                                                          BlocProvider.of<
                                                            VoucherBloc
                                                          >(context).add(
                                                            VoucherRedeem(
                                                              voucherId:
                                                                  detail.id
                                                                      .toString(),
                                                              qrCode: '',
                                                              pin:
                                                                  value
                                                                      .toString(),
                                                            ),
                                                          );
                                                        });

                                                        setProcessingStatus(
                                                          false,
                                                        );

                                                        Timer(
                                                          Duration(
                                                            milliseconds: 5,
                                                          ),
                                                          () {
                                                            slideController
                                                                .reset();
                                                          },
                                                        );
                                                      } else {
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        BlocProvider.of<
                                                            VoucherBloc
                                                          >(context)
                                                          ..reloadBack = true
                                                          ..add(
                                                            VoucherDetailsLoad(
                                                              voucherId:
                                                                  Storage()
                                                                      .voucherId,
                                                            ),
                                                          );

                                                        setProcessingStatus(
                                                          false,
                                                        );

                                                        Timer(
                                                          Duration(
                                                            milliseconds: 5,
                                                          ),
                                                          () {
                                                            slideController
                                                                .reset();
                                                          },
                                                        );
                                                      }
                                                    })
                                                : scanBarcodeNormal();
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
                                          showErrorToast(
                                            securityState.error,
                                            context,
                                          );
                                        }
                                        /* ----------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
                                        if (securityState
                                            is SecurityMaintenanceError) {
                                          Navigator.pushAndRemoveUntil<void>(
                                            context,
                                            MaterialPageRoute<void>(
                                              builder:
                                                  (
                                                    BuildContext context,
                                                  ) => MaintenanceScreen(
                                                    parameters:
                                                        MaintenanceParameters(
                                                          message:
                                                              securityState
                                                                  .message,
                                                        ),
                                                  ),
                                            ),
                                            ModalRoute.withName('/'),
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        return Column(
                                          children: [
                                            SlideButton(
                                              textButton: Text(
                                                detail.redeemMethod == 'swipe'
                                                    ? 'SWIPE TO REDEEM'
                                                    : 'SCAN QR TO REDEEM',
                                                style: TextStyle(
                                                  fontFamily: fontFamilyMain,
                                                  letterSpacing: 2,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: colorWhite,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              textSlide: Text(
                                                'Unlock',
                                                style: TextStyle(
                                                  fontFamily: fontFamilyMain,
                                                  letterSpacing: 2,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: colorWhite,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // buttonSize: height / 14,
                                              backgroundColor: colorMulberry,
                                              slideColor: colorRaspberyRed,
                                              icon: Icon(
                                                Icons.arrow_forward,
                                                color: colorWhite,
                                              ),
                                              // buttonColor: colorSlideGreen,
                                              onSlided: () async {
                                                if (detail.redeemMethod ==
                                                    'swipe') {
                                                  redeemMethod = 1;

                                                  BlocProvider.of<SecurityBloc>(
                                                    context,
                                                  ).add(SecurityStart());

                                                  return true;
                                                } else {
                                                  Storage().page =
                                                      'redeemVoucher';
                                                  redeemMethod = 2;

                                                  BlocProvider.of<SecurityBloc>(
                                                    context,
                                                  ).add(SecurityStart());

                                                  return true;
                                                }
                                              },
                                            ),
                                            Container(
                                              // child: Align(
                                              margin: EdgeInsets.only(
                                                top: 20,
                                                bottom: 16,
                                              ),
                                              alignment: Alignment.center,
                                              child: OderButtonText(
                                                detail.redeemMethod == 'swipe'
                                                    ? 'Or click to scan QR'
                                                    : 'Or click to redeem',
                                                color: colorBlack,
                                                fontSize: 16.0,
                                                underline: true,
                                                fontWeight: FontWeight.w600,
                                                // fontStyle: FontStyle.italic,
                                                onClick: () {
                                                  if (detail.redeemMethod ==
                                                      'swipe') {
                                                    Storage().page =
                                                        'redeemVoucher';
                                                    redeemMethod = 2;

                                                    BlocProvider.of<
                                                      SecurityBloc
                                                    >(
                                                      context,
                                                    ).add(SecurityStart());
                                                  } else {
                                                    redeemMethod = 1;

                                                    BlocProvider.of<
                                                      SecurityBloc
                                                    >(
                                                      context,
                                                    ).add(SecurityStart());
                                                  }
                                                  // Storage().page = 'redeemVoucher';
                                                  // redeemMethod = 2;

                                                  // BlocProvider.of<SecurityBloc>(
                                                  //         context)
                                                  //     .add(SecurityStart());
                                                  // // scanBarcodeNormal();
                                                },
                                              ),
                                              // ),
                                            ),
                                          ],
                                        );
                                      },
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

                  return Container();
                }

                return LoadingWidget();
              },
            ),
          ),
        ),
      ),
    );
  }

  /* --------------------------------------------------------------------------- Scan barcode function */
  FutureOr<void> scanBarcodeNormal() {
    /* Navigate to scan view page */
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (BuildContext context) =>
                AppBarcodeScannerWidget.defaultStyle(tabFor: 'voucher_desc'),
      ),
    ).then((value) {
      // print('QR CODE: $value');
      if (value != null) {
        qrCode = value;

        if (!mounted) return;
        Navigator.of(context).pushNamed(OderRoutes.passcodeKey).then((value) {
          if (value != null) {
            passcodePin = value.toString();

            setState(() {
              BlocProvider.of<VoucherBloc>(context).add(
                VoucherRedeem(
                  voucherId: detail.id.toString(),
                  qrCode: qrCode,
                  pin: passcodePin,
                ),
              );
            });
          } else {
            if (!mounted) return;
            BlocProvider.of<VoucherBloc>(context)
              ..reloadBack = true
              ..add(VoucherDetailsLoad(voucherId: Storage().voucherId));
          }

          setProcessingStatus(false);
          Timer(Duration(milliseconds: 5), () {
            slideController.reset();
          });
        });
      } else {
        if (!mounted) return;
        BlocProvider.of<VoucherBloc>(context)
          ..reloadBack = true
          ..add(VoucherDetailsLoad(voucherId: Storage().voucherId));

        setProcessingStatus(false);
        Timer(Duration(milliseconds: 5), () {
          slideController.reset();
        });
      }
    });
  }
}
