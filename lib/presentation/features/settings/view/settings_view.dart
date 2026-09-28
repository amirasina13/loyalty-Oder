import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../util/utils.dart';
import '../../../widgets/widgets.dart';
import '../../authentication/authentication.dart';
import '../../profile/profile.dart';

class SettingView extends StatefulWidget {
  final Function changeView;
  const SettingView({super.key, required this.changeView});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  PackageInfo? packageInfo;
  bool load = false;
  bool? clickPasscode = false;
  String? profileImage, email;
  String? versionNum, buildNum;
  final TextEditingController pinController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
      fontFamily: fontFamilyMain,
    ),
    margin: EdgeInsets.zero,
  );

  // Future _fetchPackageInfo() async {
  //   packageInfo = await PackageInfo.fromPlatform();
  // }

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
        backgroundColor: colorBackground,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Settings',
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorBlack,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
            textScaler: TextScaler.linear(scaleFactor),
            textAlign: TextAlign.left,
          ),
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(
              marginHorizontal,
              0,
              marginHorizontal,
              0,
            ),
            child: ListView(
              children: <Widget>[
                Column(
                  children: [
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   child: Text(
                    //     'Settings',
                    //     style: TextStyle(
                    //       fontFamily: fontFamilyMain,
                    //       color: colorBlack,
                    //       fontWeight: FontWeight.w700,
                    //       fontSize: 32,
                    //     ),
                    //     textScaler: TextScaler.linear(scaleFactor),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),
                    BlocConsumer<ProfileBloc, ProfileState>(
                      listener: (context, profileState) {},
                      builder: (context, profileState) {
                        Image? image;
                        String name = 'Unknown';

                        if (profileState is ProfileLoaded) {
                          var profile = profileState.userProfile.profile;

                          // ignore: unnecessary_null_comparison
                          if (profile != null) {
                            profileImage = profile.image;
                            name = profile.name!;
                            email = profile.email!;

                            if (profileImage != null) {
                              // image = profileImage!;
                              image = Image.network(
                                profileImage!,
                                fit: BoxFit.fill,
                              );
                            } else {
                              image = Image.asset('assets/icons/no_photo.png');
                            }
                          }
                        }

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 0,
                                ),
                                margin: EdgeInsets.only(bottom: 15),
                                height: ScreenSize.height * 0.06,
                                width: ScreenSize.width * 0.5,
                                // color: colorBabyBlue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: colorTransparent,
                                      ),
                                      child: ClipOval(child: image),
                                      // child: image,
                                      // ),
                                    ),
                                    SizedBox(width: 5),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: colorGrey,
                                          fontFamily: fontFamilyMain,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(text: 'Welcome\n'),
                                          TextSpan(
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: colorBlack,
                                              fontFamily: fontFamilyMain,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            text: name,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: InkWell(
                            onTap: () async {
                              BlocProvider.of<AuthenticationBloc>(
                                context,
                              ).add(AuthenticationLoggedOut());
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                OderRoutes.login,
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Image.asset(
                              'assets/icons/settings/logout-box-r-line.webp',
                              height: 25,
                              width: 25,
                              color: mainColor,
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(height: 1, color: colorGrey),
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
                    urlAboutUs != ''
                        ? Divider(height: 1, color: colorGrey)
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
                    urlFAQ != ''
                        ? Divider(height: 1, color: colorGrey)
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
                    urlTerm != ''
                        ? Divider(height: 1, color: colorGrey)
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
                    urlPolicy != ''
                        ? Divider(height: 1, color: colorGrey)
                        : SizedBox(),
                    Container(
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
