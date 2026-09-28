// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'app_setting/app_setting.dart';
import 'config/config.dart';
import 'locator.dart';
import 'presentation/features/webview/webviews.dart';
import 'presentation/navigation_service.dart';
import 'util/utils.dart';

class LifeCycleManager extends StatefulWidget {
  const LifeCycleManager({super.key, required this.child});

  final Widget child;

  @override
  State<LifeCycleManager> createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;
  bool isDeeplinkPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void _initDeepLinkListener() async {
    _appLinks = AppLinks();

    _sub = _appLinks!.uriLinkStream.listen((uri) async {
      if ((uri != null || uri.toString().isNotEmpty) &&
          uri.host == AppConfig.applink) {
        isDeeplinkPressed = true;

        TempData.deeplink = uri.toString();

        sl<NavigationService>().navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder:
                (context) => RedirectWebView(
                  parameters: DeeplinkParameters(initialUrl: uri.toString()),
                ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        var getOnboard =
            await Storage().secureStorage.read(key: 'on_boarding') ?? '0';

        if (Platform.isAndroid) {
          // if (Storage().setupDone == false) {
          //   sl<NavigationService>().navigatorKey.currentState
          //       ?.pushNamedAndRemoveUntil(
          //         OderRoutes.splash,
          //         (Route<dynamic> route) => false,
          //       );
          // } else
          if (getOnboard == '0') {
            sl<NavigationService>().navigatorKey.currentState
                ?.pushNamedAndRemoveUntil(
                  OderRoutes.onBoard,
                  (Route<dynamic> route) => false,
                );
          } else {
            _initDeepLinkListener();
            if (isDeeplinkPressed) {
              _sub?.cancel();
            }
          }
        } else {
          DeepLinkHandler.listenForDeepLinkIOS();
        }

        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
