// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance.dart';
import '../../profile/profile.dart';
import '../../security_pin/security_pin.dart';
import '../../settings/setting.dart';
import '../../voucher/voucher.dart';
import '../wallet.dart';

class WalletView extends StatefulWidget {
  final Function changeView;

  const WalletView({super.key, required this.changeView});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  String passcodePin = '';
  String? versionNum, buildNum;
  bool isProcessing = false;
  bool? clickPasscode = false;
  int? totalMyVoucher = 0;
  var profileData, height, width;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    getAppVersion();
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version; // e.g. "1.0.0"
    String buildNumber = packageInfo.buildNumber; // e.g. "1"

    setState(() {
      versionNum = version;
      buildNum = buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    double statusbarHeight = MediaQuery.of(context).padding.top;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          OderRoutes.home,
          (Route<dynamic> route) => false,
        );
      },
      child: OderScaffold(
        bottomMenuIndex: 3,
        isShow: true,
        showAppbar: false,
        extendBodyBehindAppBar: true,
        canClick: false,
        isCenterTitle: false,
        body: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is WalletLoaded) {
              profileData = state.userQrcode;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Column(
                    children: [
                      _topBody(statusbarHeight),
                      _creditPointsBalanceBody(),
                      _topupBody(),
                      _settingBody(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: marginHorizontal,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Version: ",
                                style: TextStyle(
                                  color: colorSoftGrey,
                                  fontFamily: fontFamilyMain,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "$versionNum ($buildNum)",
                                style: TextStyle(
                                  color: colorSoftGrey,
                                  fontFamily: fontFamilyMain,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return LoadingWidget();
          },
        ),
      ),
    );
  }

  Widget _topBody(statusbarHeight) {
    return Container(
      // height: height * 0.16,
      // color: colorBabyBlue,
      margin: EdgeInsets.fromLTRB(
        marginHorizontal,
        statusbarHeight,
        marginHorizontal,
        10,
      ),
      child: Column(
        children: [
          // Container(
          //   alignment: Alignment.centerRight,
          //   // color: colorWhite,
          //   padding: EdgeInsets.symmetric(vertical: 7),
          //   child: InkWell(
          //     child: SizedBox(
          //       width: height * 0.04,
          //       height: height * 0.04,
          //       child: Image(
          //         color: colorBlack,
          //         image: AssetImage('assets/icons/bottom/settings.png'),
          //       ),
          //     ),
          //     onTap: () {
          //       Navigator.of(context).pushNamed(OderRoutes.setting);
          //     },
          //   ),
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.2,
                margin: EdgeInsets.only(right: 10),
                child: AspectRatio(
                  aspectRatio: 2 / 2,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorTransparent,
                      border: Border.all(color: colorWhite, width: 2),
                    ),
                    child: ClipOval(
                      child: CachedImage(imageUrl: profileData.profile.image!),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    child: Text(
                      profileData!.profile!.name!,
                      style: TextStyle(
                        fontSize: 16,
                        color: colorBlack,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 3),
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: Text(
                      profileData!.profile!.code!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: colorBlack,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _creditPointsBalanceBody() {
    return Container(
      height: height * 0.07,
      color: colorBackground,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ------------------------------------------------------------------- My Voucher Sections
          BlocBuilder<VoucherBloc, VoucherState>(
            builder: (context, state) {
              if (state is VoucherCountLoaded) {
                totalMyVoucher = state.vouchersLength;
              }
              return Expanded(
                child: InkWell(
                  onTap: () {
                    Storage().rewardReload = '';
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        totalMyVoucher.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'My Voucher',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: colorCountGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // ------------------------------------------------------------------- Credit Balance Sections
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  OderRoutes.history,
                  arguments: HistoryParameters(selectedTab: 0),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    profileData.profile!.credits!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 7),
                  Text(
                    '$creditLabelTitle ($creditLabelText)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colorCountGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ------------------------------------------------------------------- Points Balance Sections
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  OderRoutes.history,
                  arguments: HistoryParameters(selectedTab: 1),
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    profileData.profile!.points!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 7),
                  Text(
                    pointLabelTitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: colorCountGrey,
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

  Widget _topupBody() {
    return BlocConsumer<SecurityBloc, SecurityState>(
      listener: (context, securityState) {
        setProcessingStatus(false);

        if (securityState is SecurityCheckVerified) {
          if (securityState.verified == false) {
            Storage().page = 'wallet';

            Navigator.of(context).pushNamed(OderRoutes.securityCreate).then((
              value,
            ) {
              setState(() {
                clickPasscode = false;
              });
            });
          } else {
            Storage().set = 'reset';
            Storage().page = 'wallet';

            Navigator.of(context).pushNamed(OderRoutes.securityChange).then((
              value,
            ) {
              setState(() {
                clickPasscode = false;
              });
            });
          }
        }

        if (securityState is SecurityOtpSent) {
          showSuccessToast(securityState.data['message'], context);
          Navigator.of(context).pushNamed(
            OderRoutes.securityOtp,
            arguments: SecurityOtpParameters(otpData: securityState.data),
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
      builder: (context, securityState) {
        return InkWell(
          onTap: () {},
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: marginHorizontal,
            ),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: colorLightGray,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 2.0),
                ),
              ],
            ),
            child: OderStyleButton(
              title: 'Top-up',
              onPressed: isProcessing ? () {} : _topupCredit,
              borderRadius: 10,
              backgroundColor: colorBackground,
              borderColor: colorLightGray,
              icon: Icons.add_circle_outline,
              iconSize: 25,
              iconColor: colorMulberry,
              textColor: mainColor,
            ),
          ),
        );
      },
    );
  }

  Widget _settingBody() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
          decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: colorSoftGrey,
                blurRadius: 8.0,
                offset: Offset(0.0, 2.0),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Account',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: colorBlack),
                  ),
                ),
                OderMenuLine(
                  title: 'My Account',
                  icon: Image(
                    image: AssetImage(
                      'assets/icons/settings/account-circle-line.webp',
                    ),
                  ),
                  onTap: (() {
                    // Storage().page = 'card';
                    Navigator.of(context).pushNamed(OderRoutes.profile).then((
                      value,
                    ) {
                      // if (!mounted) return;
                      // BlocProvider.of<WalletBloc>(context).add(WalletLoad());
                    });
                  }),
                ),
                SizedBox(height: height * 0.01),
                OderMenuLine(
                  title: 'Following Merchant',
                  icon: Image(
                    image: AssetImage('assets/icons/settings/user_add.webp'),
                  ),
                  onTap: (() {
                    Storage().page = '';
                    Navigator.of(context).pushNamed(OderRoutes.favMerchant);
                  }),
                ),
                SizedBox(height: height * 0.01),
                OderMenuLine(
                  title: 'Favourite Brands\' Outlets',
                  icon: Image(
                    image: AssetImage('assets/icons/settings/fav_brand.webp'),
                  ),
                  onTap: (() {
                    Storage().page = '';
                    Navigator.of(context).pushNamed(OderRoutes.favOutlet);
                  }),
                ),
                SizedBox(height: height * 0.01),
                OderMenuLine(
                  title: 'Favourite Deals',
                  icon: Image(
                    image: AssetImage('assets/icons/settings/fav-deal.webp'),
                  ),
                  onTap: (() {
                    Storage().page = '';
                    Navigator.of(context).pushNamed(OderRoutes.favDeal);
                  }),
                ),
                SizedBox(height: height * 0.01),
                OderMenuLine(
                  title: 'Transaction History',
                  icon: Image(
                    image: AssetImage('assets/icons/settings/txn_icon.webp'),
                  ), //Icons.history,
                  onTap: (() {
                    Navigator.of(context)
                        .pushNamed(
                          OderRoutes.history,
                          arguments: HistoryParameters(selectedTab: 0),
                        )
                        .then((value) {
                          if (!mounted) return;
                          BlocProvider.of<ProfileBloc>(
                            context,
                          ).add(ProfileLoad());
                        });
                  }),
                ),
                SizedBox(height: height * 0.01),
                OderMenuLine(
                  title: 'Refer Friends',
                  icon: Image(
                    image: AssetImage(
                      'assets/icons/settings/hand-heart-line.webp',
                    ),
                  ),
                  onTap: (() async {
                    // var currentBrightness = await ScreenBrightness().current;
                    // var newBrightness = 1 - currentBrightness;

                    // BrightnessCheck()
                    //     .setBrightness(currentBrightness + newBrightness);

                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamed(OderRoutes.refer).then((
                      value,
                    ) {
                      // BrightnessCheck().resetBrightness();
                      if (!mounted) return;
                      BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
                    });
                  }),
                ),
                SizedBox(height: height * 0.01),
                BlocConsumer<SecurityBloc, SecurityState>(
                  listener: (context, securityState) {
                    fToast = FToast();
                    fToast.init(context);

                    if (securityState is SecurityCheckVerified) {
                      if (securityState.verified == false) {
                        Storage().set = 'create';
                        Storage().page = 'wallet';
                        // Storage().email = email!;

                        // BlocProvider.of<SecurityBloc>(context)
                        //     .add(SecurityOtpSend());

                        Navigator.of(
                          context,
                        ).pushNamed(OderRoutes.securityCreate).then((value) {
                          setState(() {
                            clickPasscode = false;
                          });
                        });
                      } else {
                        Storage().set = 'reset';
                        Storage().page = 'wallet';
                        Navigator.of(
                          context,
                        ).pushNamed(OderRoutes.securityChange).then((value) {
                          setState(() {
                            clickPasscode = false;
                          });
                        });
                      }
                    }
                    if (securityState is SecurityOtpSent) {
                      showSuccessToast(securityState.data['message'], context);
                      Navigator.of(context)
                          .pushNamed(
                            OderRoutes.securityOtp,
                            arguments: SecurityOtpParameters(
                              otpData: securityState.data,
                            ),
                          )
                          .then((value) {
                            setState(() {
                              clickPasscode = false;
                            });
                          });
                    }
                  },
                  builder: (context, securityState) {
                    return OderMenuLine(
                      title: 'Passcode',
                      icon: Image(
                        image: AssetImage(
                          'assets/icons/settings/lock-password-line.webp',
                        ),
                      ),
                      onTap:
                          clickPasscode == false
                              ? (() {
                                setState(() {
                                  clickPasscode = true;
                                });
                                // print('ALREADY CLICK !!!!!!');
                                BlocProvider.of<SecurityBloc>(
                                  context,
                                ).add(SecurityStart());
                              })
                              : () {},
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: ScreenSize.height * 0.02),
        Container(
          margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
          decoration: BoxDecoration(
            color: colorBackground,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: colorSoftGrey,
                blurRadius: 8.0,
                offset: Offset(0.0, 2.0),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Others',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: colorBlack),
                  ),
                ),
                urlAboutUs != ''
                    ? OderMenuLine(
                      title: 'About Us',
                      icon: Image(
                        image: AssetImage(
                          'assets/icons/settings/team-line.webp',
                        ),
                      ),
                      onTap:
                          (() => {
                            Navigator.push(
                              context,
                              NoAnimationPageRoute(
                                builder: (context) {
                                  // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                  return WidgetWebView(
                                    widgetUrl: urlAboutUs,
                                    title: 'About Us',
                                  );
                                },
                              ),
                            ),
                          }),
                    )
                    : SizedBox(),
                urlFAQ != ''
                    ? OderMenuLine(
                      title: 'Help Center',
                      icon: Image(
                        image: AssetImage(
                          'assets/icons/settings/customer-service-line.webp',
                        ),
                      ),
                      onTap:
                          (() => {
                            Navigator.push(
                              context,
                              NoAnimationPageRoute(
                                builder: (context) {
                                  // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                  return WidgetWebView(
                                    widgetUrl: urlFAQ,
                                    title: 'FAQ',
                                  );
                                },
                              ),
                            ),
                          }),
                    )
                    : SizedBox(),
                urlTerm != ''
                    ? OderMenuLine(
                      title: 'Terms of Use',
                      icon: Image(
                        image: AssetImage(
                          'assets/icons/settings/file-list-2-line.webp',
                        ),
                      ),
                      onTap:
                          (() => {
                            Navigator.push(
                              context,
                              NoAnimationPageRoute(
                                builder: (context) {
                                  // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                  return WidgetWebView(
                                    widgetUrl: urlTerm,
                                    title: 'Terms of Use',
                                  );
                                },
                              ),
                            ),
                          }),
                    )
                    : SizedBox(),
                urlPolicy != ''
                    ? OderMenuLine(
                      title: 'Privacy Policy',
                      icon: Image(
                        image: AssetImage(
                          'assets/icons/settings/shield-keyhole-line.webp',
                        ),
                      ),
                      onTap:
                          (() => {
                            Navigator.push(
                              context,
                              NoAnimationPageRoute(
                                builder: (context) {
                                  // Directly return WidgetWebView, as it contains its own Scaffold and AppBar
                                  return WidgetWebView(
                                    widgetUrl: urlPolicy,
                                    title: 'Privacy Policy',
                                  );
                                },
                              ),
                            ),
                          }),
                    )
                    : SizedBox(),
                OderMenuLine(
                  title: 'Logout',
                  icon: Image(
                    image: AssetImage(
                      'assets/icons/settings/logout-box-r-line.webp',
                    ),
                    color: colorGreyExpired,
                  ),
                  onTap: (() {
                    BlocProvider.of<AuthenticationBloc>(
                      context,
                    ).add(AuthenticationLoggedOut());
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      OderRoutes.login,
                      (Route<dynamic> route) => false,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _topupCredit() {
    Navigator.of(context).pushNamed(OderRoutes.creditOnline).then((value) {
      if (!mounted) return;
      BlocProvider.of<WalletBloc>(context).add(WalletLoad());
    });
  }
}
