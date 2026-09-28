import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../navigation_service.dart';
import '../../../widgets/extensions/location_screen.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../security_pin/security_pin.dart';
import '../../voucher/voucher.dart';
import '../../webview/webviews.dart';
import '../reward.dart';

class DetailsView extends StatefulWidget {
  final Function? changeView;
  final String? title;
  final int? indexPage;

  const DetailsView({super.key, this.changeView, this.title, this.indexPage});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> with RouteAware {
  bool isProcessing = false;
  bool isSelected = false;
  String? selectedRewardID;
  // int selectedTabVoucher = 0;
  String passcodePin = '';
  String _result = '';
  List<RewardOutlet> rewardsOutlet = [];
  final TextEditingController pinController = TextEditingController();
  bool load = false;
  bool isFavouriteClick = false;
  bool isVideoClick = true;
  bool isPhotoClick = false;
  bool isFavClick = false;
  SliderButtonController slideController = SliderButtonController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final GlobalKey<VideoPlayerAppState> _videoPlayerKey = GlobalKey();
  final GlobalKey<YoutubePlayerCustomState> _youtubePlayerKey = GlobalKey();
  final GlobalKey<RedirectWebViewState> _controller = GlobalKey();

  late Timer durationLoading;

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
    if (!mounted) return;
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    initializeDateFormatting();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  /// Called when another page is pushed on top of DetailsView.
  @override
  void didPushNext() {
    _stopAllMedia();
  }

  // Future<void> _stopVideoIfActive() async {
  //   _videoPlayerKey.currentState?.stopVideo();
  // }

  // Future<void> _stopVideoYoutube() async {
  //   _youtubePlayerKey.currentState?.stopVideoYoutube();
  // }

  // Future<void> _stopWebviewDeeplink() async {
  //   _controller.currentState?.clearWebview();
  // }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _stopAllMedia();
    super.dispose();
  }

  Future<void> _stopAllMedia() async {
    _videoPlayerKey.currentState?.stopVideo();
    _youtubePlayerKey.currentState?.stopVideoYoutube();
    _controller.currentState?.clearWebview();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        _stopAllMedia();

        if (didPop) return;
        navigateBack();
      },
      child: BlocConsumer<RewardBloc, RewardState>(
        listener: (context, state) {
          // fToast = FToast();
          // fToast.init(context);

          // if (Storage().globalValue!['vouchers'] == true &&
          //     Storage().globalValue!['subscriptions'] == true) {
          //   selectedTabVoucher = 0;
          // } else if (Storage().globalValue!['vouchers'] == false) {
          //   selectedTabVoucher = 3;
          // } else {
          //   selectedTabVoucher = 0;
          // }

          /* --------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
          if (state is RewardMaintenanceError) {
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

            Timer(Duration(milliseconds: 5), () {
              slideController.reset();
            });
          }
          if (state is RewardNetworkError) {
            showErrorToast('No internet connection', context);
            Navigator.of(context).pushNamedAndRemoveUntil(
              OderRoutes.home,
              (Route<dynamic> route) => false,
            );
          }

          if (state is RewardDetailsLoaded) {
            isFavClick = false;
          }
        },
        builder: (context, state) {
          if (state is RewardOutletStarted) {
            BlocProvider.of<RewardBloc>(
              context,
            ).add(RewardDetailsLoad(rewardId: Storage().rewardId));
          }

          if (state is RewardDetailsLoaded) {
            var detail = state.details;
            var rewardId = detail.voucher?.id;
            var points = detail.member!.points;
            rewardsOutlet = state.details.outlets!;
            var formatter = DateFormat(appDateFormat);
            var dateFormateStart = formatter.format(
              DateTime.parse(detail.voucher!.start!),
            );
            var dateFormateEnd = formatter.format(
              DateTime.parse(detail.voucher!.end!),
            );
            isFavouriteClick = detail.voucher!.isFavourite!;

            if (points != null) {}

            if (rewardId != null) {
              return GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 50) {
                    _stopAllMedia();
                    navigateBack();
                  }
                },
                child: voucherDetail(
                  detail,
                  rewardId,
                  dateFormateStart,
                  dateFormateEnd,
                ),
              );
            }

            return Container();
          }
          // return Container(color: colorBackground);
          return OderScaffold(
            body: LoadingWidget(),
            bottomMenuIndex: widget.indexPage == 0 ? 0 : 3,
          );
        },
      ),
    );
  }

  Widget voucherDetail(
    DetailsData detail,
    String rewardId,
    String dateFormateStart,
    String dateFormateEnd,
  ) {
    final purchaseText = detail.voucher!.purchaseText ?? '';
    final bool isLongText = purchaseText.length > 20;

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        // ignore: use_build_context_synchronously
        BlocProvider.of<RewardBloc>(context).add(RewardOutletCheck());
      },
      child: OderScaffold(
        systemUiOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorBackground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: colorTransparent,
        ),
        title: Text(
          widget.title!,
          style: TextStyle(
            fontFamily: fontFamilyMain,
            color: colorBlack,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
          textScaler: TextScaler.linear(scaleFactor),
        ),
        leading: IconButton(
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onPressed: () {
            _stopAllMedia();

            navigateBack();
          },
        ),
        appbarAction: [
          InkWell(
            onTap: () async {
              // _onShare method: FOR IPAD
              final box = context.findRenderObject() as RenderBox?;

              final response = await get(Uri.parse(detail.voucher!.image!));
              final directory = await getTemporaryDirectory();
              File file = await File(
                '${directory.path}/Image.png',
              ).writeAsBytes(response.bodyBytes);

              if (Platform.isAndroid) {
                await Share.shareXFiles(
                  [XFile(file.path)],
                  text:
                      '${detail.voucher!.share}\n\n${detail.voucher!.shareLink}',
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size,
                );
              } else {
                await Share.share(
                  '${detail.voucher!.share}\n\n${detail.voucher!.shareLink}',
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
        bottomMenuIndex: widget.indexPage == 0 ? 0 : 3,
        showBottomNavigator: false,
        body: SafeArea(
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
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: colorBackground,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: colorGreyBox,
                                      blurRadius: 5.0,
                                      offset: Offset(0.0, 5.0),
                                    ),
                                  ],
                                ),
                                child:
                                    isPhotoClick ||
                                            (!isPhotoClick &&
                                                !detail.voucher!.isVideo!)
                                        ? CachedImage(
                                          imageUrl: detail.voucher!.image!,
                                        )
                                        : detail.voucher!.videoPath!.contains(
                                          'youtube.com',
                                        )
                                        ? YoutubePlayerCustom(
                                          key: _youtubePlayerKey,
                                          videoUrl: detail.voucher!.videoPath!,
                                        )
                                        : VideoPlayerApp(
                                          key: _videoPlayerKey,
                                          videoUrl: detail.voucher!.videoPath!,
                                        ),
                              ),
                            ),
                          ),
                          detail.voucher!.isMuslim == true
                              ? Positioned(
                                right: 20,
                                top: 5,
                                child: HalalWidget(
                                  muslimCategory:
                                      detail.voucher!.muslimCategory!,
                                  width: ScreenSize.width * 0.15,
                                ),
                              )
                              : SizedBox(),
                          Visibility(
                            visible: detail.voucher!.isVideo!,
                            child: Positioned(
                              right: 20,
                              top: 5,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isVideoClick = true;
                                        isPhotoClick = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: colorGrey),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.zero,
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.zero,
                                        ),
                                        color:
                                            isVideoClick
                                                ? colorWhite
                                                : colorBlack.withValues(
                                                  alpha: 0.5,
                                                ),
                                      ),
                                      child: Text(
                                        'Video',
                                        style: TextStyle(
                                          color:
                                              isVideoClick
                                                  ? colorBlack
                                                  : colorWhite.withValues(
                                                    alpha: 0.5,
                                                  ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isVideoClick = false;
                                        isPhotoClick = true;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: colorGrey),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.zero,
                                          topRight: Radius.circular(10.0),
                                          bottomLeft: Radius.zero,
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                        color:
                                            isPhotoClick
                                                ? colorWhite
                                                : colorBlack.withValues(
                                                  alpha: 0.5,
                                                ),
                                      ),
                                      child: Text(
                                        'Photo',
                                        style: TextStyle(
                                          color:
                                              isPhotoClick
                                                  ? colorBlack
                                                  : colorWhite.withValues(
                                                    alpha: 0.5,
                                                  ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          marginHorizontal,
                          0,
                          marginHorizontal,
                          0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                detail.voucher!.name!,
                                style: TextStyle(
                                  fontFamily: fontFamilyMain,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            InkWell(
                              child: Container(
                                // height: height * 0.07,
                                // width: width * 0.35,
                                padding: EdgeInsets.all(4),
                                // margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorBackground,
                                ),
                                child: Container(
                                  margin: EdgeInsets.all(2),
                                  child:
                                      isFavClick == false
                                          ? isFavouriteClick == false
                                              ? Icon(
                                                Icons.favorite_border,
                                                size: 30,
                                                color: colorCountGrey,
                                              )
                                              : Icon(
                                                Icons.favorite,
                                                size: 30,
                                                color: colorRaspberyRed,
                                              )
                                          : SizedBox(
                                            width: ScreenSize.width * 0.067,
                                            height: ScreenSize.width * 0.067,
                                            child: CircularProgressIndicator(
                                              color: colorSoftGrey.withValues(
                                                alpha: 0.5,
                                              ),
                                            ),
                                          ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  Storage().page = 'details_wishlist';
                                  isFavClick = true;

                                  BlocProvider.of<RewardBloc>(context).add(
                                    RewardAddRemoveFavouriteLoad(
                                      voucherId: detail.voucher!.id!.toString(),
                                      filterBy: '',
                                      filterValue: '',
                                    ),
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // height: height * 0.06,
                        margin: EdgeInsets.fromLTRB(
                          marginHorizontal,
                          8,
                          marginHorizontal,
                          20,
                        ),
                        // color: colorBabyBlue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  borderRadius: BorderRadius.circular(20),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        width: ScreenSize.width * 0.035,
                                        image: AssetImage(
                                          'assets/icons/empty_brand.webp',
                                        ),
                                        color: colorBlackTab,
                                      ),
                                      SizedBox(width: ScreenSize.width * 0.01),
                                      Text(
                                        '${detail.outlets!.length} Outlet(s)',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: mainColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                _stopAllMedia();

                                Navigator.of(context).pushNamed(
                                  OderRoutes.locationOutlet,
                                  arguments: LocationScreenParameters(
                                    locationDetails: rewardsOutlet,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: ScreenSize.height * 0.03,
                              height: ScreenSize.height * 0.03,
                              margin: EdgeInsets.only(right: 15),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: colorRedDark),
                              ),
                              child: Image(
                                image: AssetImage('assets/icons/calendar.webp'),
                                color: colorRedDark,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Valid Dates',
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 10,
                                    color: colorGreyBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                                Text(
                                  '$dateFormateStart - $dateFormateEnd',
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 12,
                                    color: colorBlack,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                              ],
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: ScreenSize.height * 0.03,
                              height: ScreenSize.height * 0.03,
                              margin: EdgeInsets.only(right: 15),
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: colorRedDark),
                              ),
                              child: Image(
                                image: AssetImage('assets/icons/coupon.webp'),
                                color: colorRedDark,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Redemption Limit',
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 11,
                                    color: colorBlack,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                                Text(
                                  '${detail.voucher!.redeem} Voucher',
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 12,
                                    color: colorBlack,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: colorDarkGray,
                        thickness: 0.2,
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
                          'Descriptions',
                          style: TextStyle(
                            fontSize: 16,
                            color: colorBlack,
                            fontFamily: fontFamilyMain,
                            fontWeight: FontWeight.w700,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
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
                          detail.voucher!.desc!,
                          style: TextStyle(
                            fontSize: 14,
                            // color: colorSoftGrey,
                            fontWeight: FontWeight.normal,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
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
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      /* --------------------------------------------------- Terms & conditions info part(from API) */
                      Container(
                        color: colorTransparent,
                        margin: EdgeInsets.fromLTRB(
                          marginHorizontal,
                          0,
                          marginHorizontal,
                          30,
                        ),
                        child: HtmlWidget(
                          detail.voucher!.tnc!,
                          customStylesBuilder: (element) {
                            // Force every element to have a specific font size
                            return {'font-size': '14'};
                          },
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
                        child: BlocConsumer<SecurityBloc, SecurityState>(
                          listener: (context, securityState) {
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
                            return SlideButton(
                              controller: slideController,
                              textButton: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      isLongText ? ScreenSize.width * 0.05 : 0,
                                ),
                                child: Text(
                                  purchaseText,
                                  maxLines: isLongText ? 2 : 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    letterSpacing: 2,
                                    fontSize: isLongText ? 12 : 15,
                                    fontWeight: FontWeight.w400,
                                    color: colorWhite,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              textSlide: Text(
                                'Get Deals',
                                style: TextStyle(
                                  fontFamily: fontFamilyMain,
                                  letterSpacing: 2,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: colorWhite,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // buttonSize: height / 14,
                              backgroundColor: colorRedDark,
                              slideColor: colorRaspberyRed,
                              icon: Icon(
                                Icons.arrow_forward,
                                color: colorWhite,
                              ),
                              // buttonColor: colorSlideGreen,
                              onSlided:
                                  detail.voucher!.isAbleRedeem == true
                                      ? isProcessing
                                          ? () {}
                                          : () async {
                                            _stopAllMedia();

                                            setProcessingStatus(true);

                                            if (detail
                                                    .voucher!
                                                    .purchaseMethod ==
                                                'either') {
                                              showPaybyModal(detail, rewardId);
                                              Timer(
                                                Duration(milliseconds: 5),
                                                () {
                                                  slideController.reset();
                                                },
                                              );

                                              // return false;
                                            } else {
                                              await Navigator.of(context)
                                                  .pushNamed(
                                                    OderRoutes.rewardConfirm,
                                                    arguments:
                                                        RewardConfirmParameters(
                                                          voucherInfo:
                                                              detail.voucher!,
                                                          indexPage: 1,
                                                          // either: '',
                                                        ),
                                                  )
                                                  .then((value) {
                                                    setProcessingStatus(false);

                                                    Timer(
                                                      Duration(milliseconds: 5),
                                                      () {
                                                        slideController.reset();
                                                      },
                                                    );
                                                  });

                                              // return true;
                                            }

                                            // BlocProvider.of<SecurityBloc>(
                                            //         context)
                                            //     .add(SecurityStart());
                                          }
                                      : () {},
                            );
                            // return Container(
                            //   margin: EdgeInsets.only(top: 10),
                            //   child: OderStyleButton(
                            //     title: '${detail.voucher!.purchaseText}',
                            //     fontFamily: fontFamilyMain,
                            //     textColor:
                            //         detail.voucher!.isAbleRedeem == true
                            //             ? isProcessing
                            //                 ? colorDarkGray
                            //                 : colorWhite
                            //             : colorDarkGray,
                            //     height: ScreenSize.height / 16,
                            //     onPressed:
                            //         detail.voucher!.isAbleRedeem == true
                            //             ? isProcessing
                            //                 ? () {}
                            //                 : () async {
                            //                   _stopVideoIfActive();
                            //                   _stopVideoYoutube();

                            //                   setProcessingStatus(true);

                            //                   if (detail
                            //                           .voucher!
                            //                           .purchaseMethod ==
                            //                       'either') {
                            //                     showPaybyModal(
                            //                       detail,
                            //                       rewardId,
                            //                     );
                            //                   } else {
                            //                     Navigator.of(context)
                            //                         .pushNamed(
                            //                           OderRoutes.rewardConfirm,
                            //                           arguments:
                            //                               RewardConfirmParameters(
                            //                                 voucherInfo:
                            //                                     detail.voucher!,
                            //                                 indexPage: 1,
                            //                                 // either: '',
                            //                               ),
                            //                         )
                            //                         .then(
                            //                           (value) =>
                            //                               setProcessingStatus(
                            //                                 false,
                            //                               ),
                            //                         );
                            //                   }

                            //                   // BlocProvider.of<SecurityBloc>(
                            //                   //         context)
                            //                   //     .add(SecurityStart());
                            //                 }
                            //             : () {},
                            //     backgroundColor:
                            //         detail.voucher!.isAbleRedeem == true
                            //             ? isProcessing
                            //                 ? colorLightGray
                            //                 : colorRedDark
                            //             : colorDisableGrey,
                            //   ),
                            // );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPaybyModal(DetailsData detail, String rewardId) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: colorBackground,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder:
          (context) => SafeArea(
            child: Padding(
              padding: EdgeInsets.zero,
              child: IntrinsicHeight(
                child: Container(
                  width: double.maxFinite,
                  // height: height / 2.5,
                  padding: EdgeInsets.all(10),
                  clipBehavior: Clip.antiAlias,
                  // padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: colorBackground,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              leading: InkWell(
                                child: Container(
                                  height: ScreenSize.height * 0.04,
                                  width: ScreenSize.height * 0.04,
                                  alignment: Alignment.centerRight,
                                  // color: colorLightGray,
                                  padding: EdgeInsets.zero,
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: colorValidGray,
                                    size: 27,
                                  ),
                                ),
                                onTap: () {
                                  setProcessingStatus(false);
                                  _result = '';
                                  Navigator.of(context).pop();
                                },
                              ),
                              title: Container(
                                alignment: Alignment.center,
                                // color: colorLightBlue,
                                child: Text(
                                  'Pay By',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: colorBlack,
                                  ),
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                              ),
                              trailing: Container(
                                height: ScreenSize.height * 0.04,
                                width: ScreenSize.height * 0.04,
                                color: colorTransparent,
                              ),
                            ),
                            creditEnable == false
                                ? Container()
                                : Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color:
                                        _result == 'credits'
                                            ? Color(0xFFEEFBEE)
                                            : colorButtonLightGrey,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color:
                                          _result == 'credits'
                                              ? Color(0xFF37D977)
                                              : colorButtonLightGrey,
                                    ),
                                  ),
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Credit(s)',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: colorBlack,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textScaler: TextScaler.linear(
                                            scaleFactor,
                                          ),
                                        ),
                                        double.parse(
                                                  detail
                                                      .voucher!
                                                      .aftDisCredits!,
                                                ) >
                                                0
                                            ? Text(
                                              '${detail.voucher!.aftDisCredits}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: colorBlack,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textScaler: TextScaler.linear(
                                                scaleFactor,
                                              ),
                                            )
                                            : Text(
                                              'Not available',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: colorRed,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textScaler: TextScaler.linear(
                                                scaleFactor,
                                              ),
                                            ),
                                      ],
                                    ),
                                    value: 'credits',
                                    groupValue: _result,
                                    activeColor: Color(0xFF37D977),
                                    onChanged:
                                        double.parse(
                                                  detail
                                                      .voucher!
                                                      .aftDisCredits!,
                                                ) >
                                                0
                                            ? (value) {
                                              setState(() {
                                                _result = value!;
                                              });
                                            }
                                            : (value) {},
                                  ),
                                ),
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color:
                                    _result == 'points'
                                        ? Color(0xFFEEFBEE)
                                        : colorButtonLightGrey,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color:
                                      _result == 'points'
                                          ? Color(0xFF37D977)
                                          : colorButtonLightGrey,
                                ),
                              ),
                              child: RadioListTile<String>(
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Point(s)',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textScaler: TextScaler.linear(
                                        scaleFactor,
                                      ),
                                    ),
                                    double.parse(
                                              detail.voucher!.aftDisPoints!,
                                            ) >
                                            0
                                        ? Text(
                                          '${detail.voucher!.aftDisPoints} ',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: colorBlack,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textScaler: TextScaler.linear(
                                            scaleFactor,
                                          ),
                                        )
                                        : Text(
                                          'Not available',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: colorRed,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textScaler: TextScaler.linear(
                                            scaleFactor,
                                          ),
                                        ),
                                  ],
                                ),
                                value: 'points',
                                groupValue: _result,
                                activeColor: Color(0xFF37D977),
                                onChanged:
                                    double.parse(
                                              detail.voucher!.aftDisPoints!,
                                            ) >
                                            0
                                        ? (value) {
                                          setState(() {
                                            _result = value!;
                                          });
                                        }
                                        : (value) {},
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: ScreenSize.width * 0.17,
                                      padding: EdgeInsets.fromLTRB(
                                        0,
                                        10,
                                        10,
                                        10,
                                      ),
                                      child: InkWell(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: colorBlack,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          textScaler: TextScaler.linear(
                                            scaleFactor,
                                          ),
                                        ),
                                        onTap: () {
                                          setProcessingStatus(false);
                                          _result = '';
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    Container(
                                      // width: width * 0.17,
                                      padding: EdgeInsets.fromLTRB(
                                        10,
                                        10,
                                        0,
                                        10,
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          setProcessingStatus(true);

                                          selectedRewardID = rewardId;

                                          Navigator.pop(context);

                                          // _checkVerified(
                                          //   detail.voucher!,
                                          //   1,
                                          // );

                                          if (_result == '' ||
                                              _result.isEmpty) {
                                            showErrorToast(
                                              'Please select a payment method',
                                              context,
                                            );
                                          } else {
                                            Navigator.of(context)
                                                .pushNamed(
                                                  OderRoutes.rewardConfirm,
                                                  arguments:
                                                      RewardConfirmParameters(
                                                        voucherInfo:
                                                            detail.voucher!,
                                                        indexPage: 1,
                                                        either: _result,
                                                      ),
                                                )
                                                .then(
                                                  (value) =>
                                                      setProcessingStatus(
                                                        false,
                                                      ),
                                                );
                                          }
                                        },
                                        child: Text(
                                          'Purchase now',
                                          style: TextStyle(
                                            // fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color:
                                                _result == ''
                                                    ? Color(0xFF979797)
                                                    : colorMulberry,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          textAlign: TextAlign.right,
                                          textScaler: TextScaler.linear(
                                            scaleFactor,
                                          ),
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
              ),
            ),
          ),
    );
  }

  void navigateBack() {
    if (TempData.deeplink.isNotEmpty) {
      TempData.deeplink = '';
      _stopAllMedia();
    }

    Navigator.of(context).pushNamedAndRemoveUntil(
      OderRoutes.voucher,
      (Route<dynamic> route) => true,
      arguments: VoucherParameters(
        selectedTab: 0,
        filterBy: 'all',
        filterValue: '1',
      ),
    );
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
