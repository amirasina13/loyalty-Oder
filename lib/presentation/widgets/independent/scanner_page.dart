import 'dart:developer';
import 'dart:io';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app_setting/app_setting.dart';
import '../../../domain/domain.dart';
import '../../../locator.dart';
import '../../features/authentication/authentication.dart';
import '../../features/maintenance/maintenance.dart';
import '../../features/rewards/reward.dart';
import '../../features/settings/setting.dart';
import '../../features/voucher/voucher.dart';
import '../widgets.dart';

/* Widget class for barcode/ qrcode scanner.  */

/// AppBarcodeScannerWidget
class AppBarcodeScannerWidget extends StatefulWidget {
  final String tabFor;

  const AppBarcodeScannerWidget.defaultStyle({super.key, required this.tabFor});

  @override
  State<AppBarcodeScannerWidget> createState() => _AppBarcodeState();
}

class _AppBarcodeState extends State<AppBarcodeScannerWidget> {
  // ignore: unused_field
  bool _isGranted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TargetPlatform platform = Theme.of(context).platform;
      // if (!kIsWeb) {
      if (platform == TargetPlatform.android ||
          platform == TargetPlatform.iOS) {
        _listenForPermissionStatus();
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    });

    // Permission.camera.status.then((value) async {
    //   print('PERMISSION CAMERA: $value');
    //   if (value == PermissionStatus.granted) {
    //     _isGranted = true;
    //   } else if (value == PermissionStatus.denied) {
    //     _listenForPermissionStatus();
    //   }
    // });
  }

  void _listenForPermissionStatus() async {
    bool isGrated = true;
    if (await Permission.camera.status.isGranted) {
      isGrated = true;
    } else {
      if (await Permission.camera.request().isGranted) {
        isGrated = true;
      }

      if (Platform.isAndroid) {
        if (await Permission.camera.isDenied ||
            await Permission.camera.isPermanentlyDenied) {
          // The user opted to never again see the permission request dialog for this
          // app. The only way to change the permission's status now is to let the
          // user manually enable it in the system settings.
          openAppSettings().then((value) {
            if (!mounted) return;
            Navigator.pop(context);
          });
        }
      }
    }
    setState(() {
      _isGranted = isGrated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Storage().page == 'voucher'
        //     ?
        MultiBlocProvider(
          providers: [
            BlocProvider<RewardBloc>(
              create:
                  (context) =>
                      RewardBloc(context: context, rewardRepository: sl()),
            ),
            BlocProvider<VoucherBloc>(create: (context) => VoucherBloc()),
          ],
          child: Expanded(
            child:
                _isGranted == true
                    ? _BarcodeScannerWidget(tabFor: widget.tabFor)
                    : Container(),
          ),
        ),
      ],
    );
  }
}

///ScannerWidget
class _BarcodeScannerWidget extends StatefulWidget {
  final String tabFor;

  // ignore: unused_element_parameter
  const _BarcodeScannerWidget({super.key, required this.tabFor});

  @override
  State<_BarcodeScannerWidget> createState() => _AppBarcodeScannerWidgetState();
}

class _AppBarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  int selectedTabVoucher = 0;
  String errorfield = '';
  bool error = false;
  bool isProcessing = false;
  bool _isProcessingScan = false;
  FocusNode voucherCodeFocus = FocusNode();

  final TextEditingController voucherCodeController = TextEditingController();
  final GlobalKey<OderInputFieldState> voucherCodeKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    // voucherCodeFocus = FocusNode();
  }

  Future<void> _resumeAfterRedeemError() async {
    // _isProcessingScan = false;
    // if (!mounted) return;
    // setProcessingStatus(false);
    // await controller?.resumeCamera();

    if (!mounted) return;
    setState(() {
      result = null;
      _isProcessingScan = false;
      setProcessingStatus(false);
    });

    // Refresh BLoC state so it doesn't stay in RewardRedeemFailed
    BlocProvider.of<RewardBloc>(context).add(RewardScannerLoad());

    // Reset camera stream session cleanly
    await controller?.pauseCamera();
    await Future.delayed(const Duration(milliseconds: 300));
    await controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    // voucherCodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(systemNavigationBarColor: colorWhite),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          if (widget.tabFor == 'voucher') {
            Navigator.of(context).pushNamedAndRemoveUntil(
              OderRoutes.voucher,
              (Route<dynamic> route) => false,
              arguments: VoucherParameters(
                selectedTab: 0,
                filterBy: 'all',
                filterValue: '1',
              ),
            );
          } else {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: colorTransparent,
          extendBodyBehindAppBar: true,
          body: BlocConsumer<RewardBloc, RewardState>(
            listener: (context, rewardState) {
              if (rewardState is RewardRedeemSuccess) {
                selectedTabVoucher = 0;
                RewardSuccessDialog.showRewardSuccessDialog(
                  context,
                  rewardState.redeemResponse,
                  // '${rewardState.redeemResponse['message']} \n\n ${rewardState.redeemResponse['data']['message']}',
                  () {
                    if (rewardState.redeemResponse['data']['type'] ==
                        'voucher') {
                      BlocProvider.of<VoucherBloc>(context).add(
                        VoucherCategoriesLoad(
                          filterBy: 'all',
                          filterValue: 'all',
                        ),
                      );
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.voucher,
                        (Route<dynamic> route) => false,
                        arguments: VoucherParameters(
                          selectedTab: 1,
                          filterBy: 'all',
                          filterValue: '0',
                        ),
                      );
                    } else if (rewardState.redeemResponse['data']['type'] ==
                        'point') {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.history,
                        (Route<dynamic> route) => false,
                        arguments: HistoryParameters(selectedTab: 1),
                      );
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        OderRoutes.history,
                        (Route<dynamic> route) => false,
                        arguments: HistoryParameters(selectedTab: 0),
                      );
                    }
                  },
                );
              }
              if (rewardState is RewardRedeemFailed) {
                Storage().rewardReload = 'yes';
                _resumeAfterRedeemError();

                showErrorScannerToast(
                  rewardState.redeemResponse['message']?.toString() ??
                      'Unable to redeem this QR code.',
                  context,
                );
              }
              if (rewardState is RewardError) {
                _resumeAfterRedeemError();
                showErrorToast(rewardState.error, context);
              }
              if (rewardState is RewardNetworkError) {
                _resumeAfterRedeemError();
                showErrorToast(rewardState.error, context);
              }
              if (rewardState is RewardSessionError) {
                sessionExpiredLogOut(rewardState.error);
              }
              /* --------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
              if (rewardState is RewardMaintenanceError) {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder:
                        (BuildContext context) => MaintenanceScreen(
                          parameters: MaintenanceParameters(
                            message: rewardState.message,
                          ),
                        ),
                  ),
                  ModalRoute.withName('/'),
                );
              }
            },
            builder: (context, state) {
              return SafeArea(
                child: Center(
                  child: Stack(
                    // fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      // controller.getCameraInfo
                      // LoadingWidget(),
                      _buildQrView(context),
                      Positioned(
                        bottom: ScreenSize.height * 0.25,
                        child: SizedBox(
                          width: ScreenSize.width - 30,
                          child: Center(
                            child: Text(
                              Storage().page == 'voucher' ||
                                      Storage().page == 'redeemVoucher'
                                  ? 'Place QR code in the scan area'
                                  : scanning == 'qr'
                                  ? 'Place QR code in the scan area'
                                  : 'Place barcode in the scan area',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: ScreenSize.height * 0.01,
                        // right: -10,
                        child: Container(
                          height: ScreenSize.height / 12,
                          width: ScreenSize.width,
                          margin: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: SizedBox(
                                  width: ScreenSize.width * 0.2,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: colorWhite,
                                  ),
                                ),
                                onTap: () {
                                  if (widget.tabFor == 'voucher') {
                                    Navigator.of(
                                      context,
                                    ).pushNamedAndRemoveUntil(
                                      OderRoutes.voucher,
                                      (Route<dynamic> route) => false,
                                      arguments: VoucherParameters(
                                        selectedTab: 0,
                                        filterBy: 'all',
                                        filterValue: '1',
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: ScreenSize.width * 0.2,
                                  alignment: Alignment.center,
                                  child: FutureBuilder(
                                    future: controller?.getFlashStatus(),
                                    builder: (context, snapshot) {
                                      // return Text('Flash: ${snapshot.data}');

                                      return snapshot.data == false
                                          ? Icon(
                                            Icons.flash_on,
                                            color: colorWhite,
                                            size: 26,
                                          )
                                          : Icon(
                                            Icons.flash_on,
                                            color: colorGoldButton,
                                            size: 26,
                                          );
                                    },
                                  ),
                                ),
                                onTap: () async {
                                  await controller?.toggleFlash();
                                  // controller!.resumeCamera();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      (Storage().page == 'voucher')
                          ? Positioned(
                            bottom: ScreenSize.height * 0.03,
                            child: InkWell(
                              child: Container(
                                height: ScreenSize.height / 14,
                                width: ScreenSize.width - 30,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  color: colorGoldButton,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.only(top: 30),
                                child: Center(
                                  child: Text(
                                    'Enter Promo Code',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () async {
                                if (!mounted) return;

                                // Stop QR detection before showing the manual-entry sheet.
                                // Otherwise the camera stream can continue redeeming codes
                                // behind the sheet while the user is typing.
                                await controller?.pauseCamera();
                                if (!context.mounted) return;

                                launchManual(context);
                                voucherCodeFocus.requestFocus();
                              },
                            ),
                          )
                          : SizedBox(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 ||
                MediaQuery.of(context).size.height < 400)
            ? 280.0
            : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      // overlayMargin: EdgeInsets.only(bottom: 60),
      overlay: QrScannerOverlayShape(
        borderColor: colorGoldButton,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      controller.resumeCamera();
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (!mounted) return;

      if (_isProcessingScan ||
          scanData.code == null ||
          scanData.code!.isEmpty) {
        return;
      }

      setState(() {
        _isProcessingScan = true;
        result = scanData;

        // if (result!.code!.isNotEmpty) {
        //   // controller.pauseCamera();
        //   // controller.stopCamera();

        //   if (Storage().page == 'voucher') {
        //     BlocProvider.of<RewardBloc>(
        //       context,
        //     ).add(RewardRedeemQrLoad(code: result!.code!));
        //   } else if (Storage().page == 'referral') {
        //     controller.stopCamera();
        //     Future.delayed(Duration.zero, () {
        //       if (!mounted) return;
        //       Navigator.pop(context, result!.code!);
        //     });
        //   } else {
        //     controller.stopCamera();
        //     Future.delayed(Duration.zero, () {
        //       if (!mounted) return;
        //       Navigator.popAndPushNamed(
        //         context,
        //         OderRoutes.voucherDesc,
        //         result: result!.code!.toString(),
        //       );
        //       // Navigator.pushNamedAndRemoveUntil(
        //       //     context, OderRoutes.voucherDesc, (route) => false);
        //     });
        //   }
        // }
      });

      if (Storage().page == 'voucher') {
        // Pause camera to stop stream emissions while redeeming voucher
        await controller.pauseCamera();

        if (!mounted) return;
        BlocProvider.of<RewardBloc>(
          context,
        ).add(RewardRedeemQrLoad(code: result!.code!));
      } else if (Storage().page == 'referral') {
        await controller.stopCamera();

        Future.delayed(Duration.zero, () {
          if (!mounted) return;
          Navigator.pop(context, result!.code!);
        });
      } else {
        // Default / fallback behavior for voucherDesc navigation
        await controller.stopCamera();

        Future.delayed(Duration.zero, () {
          if (!mounted) return;
          Navigator.popAndPushNamed(
            context,
            OderRoutes.voucherDesc,
            result: result!.code!.toString(),
          );
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('no Permission')));
    }
  }

  launchManual(BuildContext context) async {
    // final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      backgroundColor: colorBackground,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: ScreenSize.height * 0.35,
                padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: CustomScrollView(
                  primary: false,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Text(
                              'Enter Voucher Code',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF03053D),
                                fontWeight: FontWeight.w600,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 30),
                            decoration: BoxDecoration(
                              color: colorBackground,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      error
                                          ? colorRed
                                          : errorfield == 'error' ||
                                              errorfield == 'errorCode'
                                          ? colorRed
                                          : colorGreyBox,
                                  // blurRadius: 15.0,
                                  offset: Offset(
                                    0.0,
                                    error
                                        ? 3
                                        : errorfield == 'error' ||
                                            errorfield == 'errorCode'
                                        ? 3
                                        : 0,
                                  ),
                                ),
                              ],
                              border: Border.all(color: colorGreyBox),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            // child: Padding(
                            // padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                            child: OderInputField(
                              key: voucherCodeKey,
                              controller: voucherCodeController,
                              textAlign: TextAlign.start,
                              textAlignVertical: TextAlignVertical.center,
                              hint: '',
                              validator: Validator.valueExists,
                              keyboard: TextInputType.text,
                              border: InputBorder.none,
                              focusNode: voucherCodeFocus,
                              textCapitalization: TextCapitalization.characters,
                              onValueChanged: (value) {
                                if (value != '') {
                                  if (mounted) return;
                                  setState(() {
                                    errorfield = '';
                                    error = false;
                                    voucherCodeKey.currentState?.validate();
                                  });
                                }
                              },
                            ),
                            // ),
                          ),
                          OderStyleButton(
                            height: ScreenSize.height / 14,
                            title: isProcessing ? 'Processing...' : 'Redeem',
                            backgroundColor:
                                isProcessing ? colorLightGray : mainColor,
                            textColor:
                                isProcessing ? colorDarkGray : colorWhite,
                            onPressed:
                                isProcessing
                                    ? () {}
                                    : () {
                                      modalSetState(() {
                                        FocusScope.of(context).unfocus();
                                        Navigator.pop(context);

                                        _validateAndSend();
                                      });
                                    },
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: OderButtonText(
                              'Cancel',
                              color: colorBlackTab,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              underline: true,
                              onClick: () {
                                // Close only the manual-entry sheet. The scanner route stays
                                // underneath and is resumed in `whenComplete` below.
                                Navigator.pop(context);
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
          },
        );
      },
    ).whenComplete(() async {
      if (!mounted) return;
      setProcessingStatus(false);
      await controller?.resumeCamera();
      voucherCodeController.clear();
      voucherCodeFocus.unfocus();
    });
  }

  void _validateAndSend() {
    if (voucherCodeKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorCode';
      voucherCodeFocus.requestFocus();
      showErrorToast('The voucher code is required !', context);
    } else {
      errorfield = '';

      // setState(() {
      setProcessingStatus(true);
      BlocProvider.of<RewardBloc>(
        context,
      ).add(RewardRedeemQrLoad(code: voucherCodeController.text.trim()));
      // });
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
