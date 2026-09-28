// WidgetWebView.dart - No changes needed from the previous full code,
// as it already includes the Scaffold and AppBar.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';

import '../../../app_setting/app_setting.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
}

class WidgetWebView extends StatefulWidget {
  final Function? changeView;
  final String? widgetUrl;
  final String title;

  const WidgetWebView({
    super.key,
    this.changeView,
    this.widgetUrl,
    required this.title,
  });

  @override
  // ignore: no_logic_in_create_state
  State<WidgetWebView> createState() => _WidgetWebViewState(widgetUrl, title);
}

class _WidgetWebViewState extends State<WidgetWebView> {
  // ignore: prefer_typing_uninitialized_variables
  var url;
  String? widgetUrl;
  String title;
  bool isLoading = true;
  final GlobalKey webViewKey = GlobalKey();

  _WidgetWebViewState(this.widgetUrl, this.title);

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone;",
    iframeAllowFullscreen: true,
  );

  PullToRefreshController? pullToRefreshController;
  late ContextMenu contextMenu;
  double progress = 0;

  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
      menuItems: [
        ContextMenuItem(
          id: 1,
          title: "Special",
          action: () async {
            await webViewController?.clearFocus();
          },
        ),
      ],
      settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
      onCreateContextMenu: (hitTestResult) async {},
      onHideContextMenu: () {},
      onContextMenuActionItemClicked: (contextMenuItemClicked) async {},
    );

    pullToRefreshController =
        kIsWeb ||
                ![
                  TargetPlatform.iOS,
                  TargetPlatform.android,
                ].contains(defaultTargetPlatform)
            ? null
            : PullToRefreshController(
              settings: PullToRefreshSettings(color: Colors.blue),
              onRefresh: () async {
                if (defaultTargetPlatform == TargetPlatform.android) {
                  webViewController?.reload();
                } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                  webViewController?.loadUrl(
                    urlRequest: URLRequest(
                      url: await webViewController?.getUrl(),
                    ),
                  );
                }
              },
            );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevents default back button behavior
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        if (webViewController != null) {
          bool canGoBackInWebView = await webViewController!.canGoBack();
          if (canGoBackInWebView) {
            webViewController!.goBack();
            return;
          }
        }

        // ignore: use_build_context_synchronously
        final NavigatorState navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
        } else {
          if (defaultTargetPlatform == TargetPlatform.android) {
            final now = DateTime.now();
            if (currentBackPressTime == null ||
                now.difference(currentBackPressTime!) >
                    const Duration(seconds: 2)) {
              currentBackPressTime = now;
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Press back again to exit')),
              // );
              return;
            }
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: colorGoldButton,
            systemNavigationBarColor: colorWhite,
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              fontFamily: fontFamilyMain,
              color: colorBlack,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            textScaler: TextScaler.linear(scaleFactor),
          ),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor: colorGoldButton,
          iconTheme: IconThemeData(color: colorBlack),
          elevation: 0,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(widget.widgetUrl!)),
                initialSettings: settings,
                contextMenu: contextMenu,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) async {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                    isLoading = true;
                  });
                },
                onPermissionRequest: (controller, request) async {
                  final currentUrl = await controller.getUrl();

                  // Allow camera/microphone for any secure HTTPS website
                  if (currentUrl?.scheme == 'https') {
                    return PermissionResponse(
                      resources: request.resources,
                      action: PermissionResponseAction.GRANT,
                    );
                  }

                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.DENY,
                  );
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final uri = navigationAction.request.url;

                  if (uri == null) return NavigationActionPolicy.CANCEL;

                  // Only allow standard http and https web links
                  if (uri.scheme == 'https' || uri.scheme == 'http') {
                    return NavigationActionPolicy.ALLOW;
                  }

                  // Block unsafe or custom app schemes (e.g., file:, data:, intent:)
                  return NavigationActionPolicy.CANCEL;
                },
                onLoadStop: (controller, url) {
                  pullToRefreshController?.endRefreshing();
                  setState(() {
                    this.url = url.toString();
                    isLoading = false;
                  });
                },
                onReceivedError: (controller, request, error) {
                  pullToRefreshController?.endRefreshing();
                  setState(() {
                    isLoading = false;
                  });
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController?.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                onUpdateVisitedHistory: (controller, url, isReload) {
                  setState(() {
                    this.url = url.toString();
                  });
                },
                onConsoleMessage: (controller, consoleMessage) {
                  // print(consoleMessage);
                },
              ),
              if (isLoading && progress < 1.0)
                Container(
                  color: colorBackground,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Loading...',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            color: colorSoftGrey,
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(height: 8),
                        CircularProgressIndicator(color: colorDisableGrey),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
