import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../locator.dart';
import '../presentation/features/webview/webview_deeplink.dart';
import '../presentation/navigation_service.dart';

class DeepLinkHandler {
  static final MethodChannel _channel = MethodChannel("deeplink_channel");

  static Future<void> listenForDeepLinkIOS() async {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "getDeepLink") {
        final deepLink = call.arguments as String?;

        if (deepLink != null) {
          // Handle the deep link in Flutter
          TempData.deeplink = deepLink;

          // Add your logic to process the deep link
          sl<NavigationService>().navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder:
                  (context) => RedirectWebView(
                    parameters: DeeplinkParameters(initialUrl: deepLink),
                  ),
            ),
          );
        } else {}
      }
    });
  }
}
