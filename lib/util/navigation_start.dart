import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_setting/app_setting.dart';
import '../presentation/features/authentication/authentication.dart';
import '../presentation/features/forgot_pass/forgot_pass.dart';
import '../presentation/features/rewards/reward.dart';
import '../presentation/features/setup/setup.dart';
import '../presentation/features/splash/splash.dart';
import '../presentation/features/webview/webviews.dart';

class AuthFlowCoordinator {
  static void handleAuthentication(
    BuildContext context,
    Map authData, {
    bool isRegisterEmail = true,
    bool isMuslimFriendly = false,
    dynamic initialMessage,
    String deepLink = '',
    String voucherId = '',
  }) {
    final loginData = authData;
    Storage().dataCheck = loginData;

    if (loginData['isResetPassword'] == true) {
      _handleResetPassword(context, loginData, isRegisterEmail);
      return;
    }

    final checkOrder =
        isRegisterEmail ? ['email', 'contact'] : ['contact', 'email'];
    for (var type in checkOrder) {
      if (type == 'email') {
        if (isEmailRequired && !loginData['eValid']) {
          _runNav(
            context,
            OderRoutes.setupEValid,
            EValidParameters(loginData: loginData),
          );
          return;
        }
      }

      // Check contact validation
      if (type == 'contact') {
        if (isContactRequired && !loginData['cValid']) {
          _runNav(
            context,
            OderRoutes.setupCValid,
            CValidParameters(profile: loginData),
          );
          return;
        }
      }

      // if (type == 'email' && isEmailRequired && !loginData['eValid']) {
      //   _runNav(
      //     context,
      //     OderRoutes.setupEValid,
      //     EValidParameters(loginData: loginData),
      //   );
      //   return;
      // }
      // if (type == 'contact' && isContactRequired && loginData['cValid']) {
      //   _runNav(
      //     context,
      //     OderRoutes.setupCValid,
      //     CValidParameters(profile: loginData),
      //   );
      //   return;
      // }
    }

    if (loginData['vProfile'] == false) {
      _runNav(
        context,
        OderRoutes.setupVProfile,
        VProfileParameters(profile: loginData),
      );
    } else if (isMuslimFriendly && loginData['vMuslim'] == false) {
      _runNav(
        context,
        OderRoutes.setupVMuslim,
        VMuslimParameters(profile: loginData),
      );
    }
    // Check deeplink
    else if (deepLink.isNotEmpty) {
      handleDeeplink(context, deepLink);
    } else if (voucherId.isNotEmpty) {
      _runNav(
        context,
        OderRoutes.rewardDetails,
        RewardDetailsParameters(rewardId: voucherId, title: '', indexPage: 3),
      );
    } else {
      // 4. Final Routing
      handleFinalDestination(context, initialMessage);
    }
  }

  // --- STATIC HELPERS ---

  static void _runNav(BuildContext context, String route, dynamic args) {
    Storage().setupDone = false;

    void navigate() => Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(route, (r) => false, arguments: args);

    if (Storage().welcomeSplash?.isNotEmpty ?? false) {
      SplashTimerDialog.showSplashLoginDialog(context, navigate);
    } else {
      navigate();
    }
  }

  static void _handleResetPassword(
    BuildContext context,
    Map loginData,
    bool isRegisterEmail,
  ) {
    Storage().setupDone = false;

    void action() {
      BlocProvider.of<AuthenticationBloc>(
        context,
      ).add(AuthenticationLoggedOut());
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(OderRoutes.login, (r) => false);
      Navigator.pushNamed(
        context,
        OderRoutes.resetPassword,
        arguments: ResetPassParameters(
          method:
              isRegisterEmail
                  ? loginData['profile']['email']
                  : loginData['profile']['contact'],
          vToken: loginData['vToken'],
        ),
      );
    }

    if (Storage().welcomeSplash?.isNotEmpty ?? false) {
      SplashTimerDialog.showSplashLoginDialog(context, action);
    } else {
      action();
    }
  }

  static void handleDeeplink(BuildContext context, String deeplink) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => RedirectWebView(
              parameters: DeeplinkParameters(initialUrl: deeplink),
            ),
      ),
    );
  }

  static void handleFinalDestination(
    BuildContext context,
    dynamic initialMessage,
  ) {
    final data = initialMessage?.data;

    // Voucher Logic
    if (data != null && data['target'] == 'voucher') {
      Navigator.of(context).pushNamedAndRemoveUntil(
        OderRoutes.rewardDetails,
        (r) => false,
        arguments: RewardDetailsParameters(
          rewardId: data['target_id'],
          title: data['target_title'],
          indexPage: 3,
        ),
      );
      return;
    }

    // Default Home Logic
    void goHome() => Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(OderRoutes.home, (r) => false);

    if (Storage().welcomeSplash?.isNotEmpty ?? false) {
      SplashTimerDialog.showSplashLoginDialog(context, goHome);
    } else {
      goHome();
    }
  }
}
