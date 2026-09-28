import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_setting/app_setting.dart';
import '../../../../locator.dart';
import '../../../widgets/widgets.dart';
import '../../country/country.dart';
import '../../home/home.dart';
import '../../profile/profile.dart';
import '../../wallet/wallet.dart';
import '../../webview/webviews.dart';
import '../authentication.dart';

class OnBoard3View extends StatefulWidget {
  const OnBoard3View({super.key});

  @override
  State<OnBoard3View> createState() => _OnBoard3ViewState();
}

class _OnBoard3ViewState extends State<OnBoard3View> {
  int currentPage = 0;
  double dragStartX = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create:
          (context) => AuthenticationBloc(
            profileBloc: BlocProvider.of<ProfileBloc>(context),
            homeBloc: BlocProvider.of<HomeBloc>(context),
            walletBloc: BlocProvider.of<WalletBloc>(context),
            countryBloc: BlocProvider.of<CountryBloc>(context),
            userRepository: sl(),
            globalRepository: sl(),
          ),
      child: Scaffold(
        backgroundColor: colorWhite,
        body: GestureDetector(
          onHorizontalDragStart: (details) {
            dragStartX = details.globalPosition.dx;
          },
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0) {
              // Swipe Right Detected
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          LoadingOnboard(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(1.0, 0.0); // Slide from right
                    const end = Offset.zero;
                    const curve = Curves.fastEaseInToSlowEaseOut;

                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  transitionDuration: Duration(
                    milliseconds: 500,
                  ), // Adjust as needed
                ),
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) =>
                          OnBoard2View(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    const begin = Offset(-1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.fastOutSlowIn;

                    var tween = Tween(
                      begin: begin,
                      end: end,
                    ).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
                ModalRoute.withName('/'),
              );
            }
          },
          child: Container(
            height: ScreenSize.height,
            width: ScreenSize.width,
            padding: EdgeInsets.fromLTRB(
              marginHorizontal,
              ScreenSize.height * 0.115,
              marginHorizontal,
              0,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/onboard1.webp'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                Image(
                  image: AssetImage(mainLogo),
                  height: ScreenSize.height * 0.13,
                ),
                SizedBox(height: ScreenSize.height * 0.07),
                Image(
                  image: AssetImage('assets/image/img_board3.webp'),
                  height: ScreenSize.height * 0.33,
                ),
                SizedBox(height: ScreenSize.height * 0.03),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    'Congrats, you\'re in! 🎉',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: fontFamilyMain,
                      color: colorBlackText,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    'More amazing deals are waiting for you — dive in now and start saving on your favorite items!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      fontFamily: fontFamilyMain,
                      color: colorBlackText,
                    ),
                  ),
                ),
                SizedBox(height: ScreenSize.height * 0.05),
                Container(
                  padding: EdgeInsets.only(bottom: ScreenSize.height * 0.02),
                  child: _buildIndicator(),
                ),
                Expanded(
                  child: InkWell(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      margin: EdgeInsets.fromLTRB(
                        15,
                        0,
                        15,
                        ScreenSize.height * 0.07,
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: fontFamilyMain,
                          color: colorBlackText,
                        ),
                      ),
                    ),
                    onTap: () {
                      BlocProvider.of<AuthenticationBloc>(
                        context,
                      ).add(AuthenticationOnBoardingComplete());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          width: ScreenSize.width * 0.05,
          height: 10.0,
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            shape: currentPage == index ? BoxShape.rectangle : BoxShape.circle,
            color: currentPage == index ? colorYellowIndicator : colorWhite,
            border: Border.all(color: colorYellowIndicator),
            borderRadius:
                currentPage == index ? BorderRadius.circular(10) : null,
          ),
        );
      }),
    );
  }

  Route createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right for forward
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: Duration(milliseconds: 500),
    );
  }
}

class LoadingOnboard extends StatefulWidget {
  const LoadingOnboard({super.key});

  @override
  State<LoadingOnboard> createState() => _LoadingOnboardState();
}

class _LoadingOnboardState extends State<LoadingOnboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create:
          (context) => AuthenticationBloc(
            profileBloc: BlocProvider.of<ProfileBloc>(context),
            homeBloc: BlocProvider.of<HomeBloc>(context),
            walletBloc: BlocProvider.of<WalletBloc>(context),
            countryBloc: BlocProvider.of<CountryBloc>(context),
            userRepository: sl(),
            globalRepository: sl(),
          ),
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationUnauthenticated) {
            if (TempData.deeplink.isNotEmpty) {
              // Storage().setupDone = true;
              // Navigate to webview to intercept the URL - convert from short URL to long URL
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => RedirectWebView(
                          parameters: DeeplinkParameters(
                            initialUrl: TempData.deeplink,
                          ),
                        ),
                  ),
                );
              }
            } else {
              // Storage().setupDone = true;
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OderRoutes.login,
                  (Route<dynamic> route) => false,
                );
              }
            }
          }
        },
        builder: (context, state) {
          BlocProvider.of<AuthenticationBloc>(
            // ignore: use_build_context_synchronously
            context,
          ).add(AuthenticationOnBoardingComplete());

          return Scaffold(
            body: Center(
              child: Container(
                height: ScreenSize.height,
                width: ScreenSize.width,
                padding: EdgeInsets.fromLTRB(
                  marginHorizontal,
                  0,
                  // ScreenSize.height * 0.05,
                  marginHorizontal,
                  0,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/image/background_signin.webp'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: LoadingWidget(backgroundColor: colorTransparent),
                ),

                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: ScreenSize.width * 0.35,
                //       // margin: EdgeInsets.only(bottom: 5),
                //       child: Text(
                //         'Loading',
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontWeight: FontWeight.w500,
                //           color: colorMulberry,
                //         ),
                //         textAlign: TextAlign.center,
                //       ),
                //       // child: Image(image: AssetImage(appLogo)),
                //     ),
                //     LoadingAnimationWidget.horizontalRotatingDots(
                //       color: colorMulberry,
                //       size: ScreenSize.width * 0.15,
                //     ),
                //   ],
                // ),
              ),
            ),
          );
        },
      ),
    );
  }
}
