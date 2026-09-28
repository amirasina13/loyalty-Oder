import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../data/data.dart';
import '../../../widgets/widgets.dart';
import '../../profile/profile.dart';
import '../../refer/refer.dart';

class ReferView extends StatefulWidget {
  final Function? changeView;

  const ReferView({super.key, this.changeView});

  @override
  State<ReferView> createState() => _ReferViewState();
}

class _ReferViewState extends State<ReferView> {
  final GlobalKey<OderInputFieldState> codeKey = GlobalKey();
  final TextEditingController codeController = TextEditingController();
  late FocusNode codeFocus;
  //Variables needed to adapt FlexibleSpaceBar text color (title)
  late ScrollController _scrollController;
  bool lastStatus = true;
  double height = 200;
  History? pointHistory;
  var pointTransactionHistoryTiles = [];
  List<Records> records = <Records>[];

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();

    codeFocus = FocusNode();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var qrSize = ScreenSize.width * 0.55;

    return BlocConsumer<ReferBloc, ReferState>(
      listener: (context, state) {},
      builder: (context, state) {
        var textMessage = '', code = '', link = '';

        if (state is ReferLoaded) {
          var refer = state.userRefer;
          textMessage = refer.text!;
          code = refer.code!;
          link = refer.link!;

          // String qrcode = refer.qr!;
          // String barcode = refer.barcode!;
          String codeString = refer.codeString!;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: colorRedDark,
              statusBarIconBrightness: Brightness.light,
              systemNavigationBarColor: colorWhite,
            ),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: height * 1.6,
                    // color: colorBabyBlue,
                    child: Stack(
                      children: [
                        Container(
                          width: ScreenSize.width,
                          height: height * 1.1,
                          padding: EdgeInsets.fromLTRB(
                            marginHorizontal,
                            70,
                            marginHorizontal,
                            0,
                          ),
                          decoration: BoxDecoration(color: colorRedDark),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                color: colorWhite,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                'Invite Friends \nEarn and redeem rewards',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                        BlocConsumer<ProfileBloc, ProfileState>(
                          listener: (context, state) {},
                          builder: (context, state) {
                            var totalPoints = '0.00';

                            if (state is ProfileLoaded) {
                              totalPoints =
                                  state.userProfile.profile!.points.toString();
                            }
                            return Positioned.fill(
                              top: height * 0.7,
                              child: Container(
                                width: ScreenSize.width,
                                height: height * 0.3,
                                margin: EdgeInsets.symmetric(
                                  horizontal: marginHorizontal,
                                ),
                                decoration: BoxDecoration(
                                  color: colorWhite,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: colorGreyBox,
                                      blurRadius: 1.0,
                                      spreadRadius: 1,
                                      offset: Offset(0.0, 0.0),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(marginHorizontal),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: height * 0.15,
                                            margin: EdgeInsets.only(right: 7),
                                            child: Image(
                                              image: AssetImage(
                                                'assets/icons/settings/txn-coin.webp',
                                              ),
                                              color: colorBlack,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  pointLabelAlign == 'left'
                                                      ? '$pointLabelText $totalPoints '
                                                      : '$totalPoints $pointLabelText ',
                                                  style: TextStyle(
                                                    fontFamily: fontFamilyMain,
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Total points earned',
                                                style: TextStyle(
                                                  fontFamily: fontFamilyMain,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 20,
                                        ),
                                        child: Divider(
                                          height: 1,
                                          thickness: 1.1,
                                          color: colorGrey,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                  bottom: 5,
                                                ),
                                                child: Text(
                                                  'Referral Friends',
                                                  style: TextStyle(
                                                    fontFamily: fontFamilyMain,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: colorSocialGrey,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Share this link with your friends',
                                                style: TextStyle(
                                                  fontFamily: fontFamilyMain,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      colorOutletAddressLabelGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              final box =
                                                  context.findRenderObject()
                                                      as RenderBox?;
                                              final bytes = await rootBundle
                                                  .load(
                                                    'assets/logo/Oder_rect.png',
                                                  );
                                              final list =
                                                  bytes.buffer.asUint8List();

                                              final tempDir =
                                                  await getTemporaryDirectory();
                                              final file =
                                                  await File(
                                                    '${tempDir.path}/image.jpg',
                                                  ).create();
                                              file.writeAsBytesSync(list);

                                              await Share.share(
                                                '$textMessage\n\n$link',
                                                sharePositionOrigin:
                                                    box!.localToGlobal(
                                                      Offset.zero,
                                                    ) &
                                                    box.size,
                                              );
                                            },
                                            child: Container(
                                              width: ScreenSize.width * 0.23,
                                              height: height * 0.2,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: colorSocialBoxGrey,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 5,
                                                    ),
                                                    child: Image(
                                                      width:
                                                          ScreenSize.width *
                                                          0.045,
                                                      image: AssetImage(
                                                        'assets/icons/wallet/upload.webp',
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    'Share',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: ScreenSize.width,
                    margin: EdgeInsets.fromLTRB(
                      marginHorizontal,
                      25,
                      marginHorizontal,
                      0,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: marginHorizontal,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: colorGreyBox,
                          blurRadius: 1.0,
                          spreadRadius: 1,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          code,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: colorReferGrey,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // Copy to clipboard code
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                width: ScreenSize.width * 0.3,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                content: Text(
                                  'Copied!',
                                  textAlign: TextAlign.center,
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                                backgroundColor: colorUsedGray,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Container(
                            width: ScreenSize.width * 0.3,
                            height: height * 0.2,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: colorGoldButton,
                              borderRadius: BorderRadius.circular(8),
                              // border: Border.all(color: colorSocialBoxGrey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Image(
                                    width: ScreenSize.width * 0.045,
                                    image: AssetImage(
                                      'assets/icons/wallet/copycode.webp',
                                    ),
                                  ),
                                ),
                                Text(
                                  'Copy Code',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    width: ScreenSize.width,
                    margin: EdgeInsets.fromLTRB(
                      marginHorizontal,
                      25,
                      marginHorizontal,
                      20,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: marginHorizontal,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: colorWhite,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: colorGreyBox,
                          blurRadius: 1.0,
                          spreadRadius: 1,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          color: colorTransparent,
                          alignment: Alignment.center,
                          // height: height / 14,
                          width: ScreenSize.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: colorValidGray,
                                ),
                              ),
                              Text(
                                'Scan QR Code',
                                // scanning == 'qr'
                                //     ? 'Scan QR Code'
                                //     : 'Scan Barcode',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: colorBlack,
                                  fontFamily: fontFamilyMain,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: PrettyQrView.data(
                            data: codeString,
                            decoration: const PrettyQrDecoration(
                              image: PrettyQrDecorationImage(
                                image: AssetImage(
                                  'assets/logo/order_splash_logo.png',
                                ),
                              ),
                              quietZone: PrettyQrQuietZone.standart,
                            ),
                            errorCorrectLevel: QrErrorCorrectLevel.Q,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return LoadingWidget();
      },
    );
  }
}

extension StringExtension on String {
  String get capitalize => "${this[0].toUpperCase()}${substring(1)}";
}
