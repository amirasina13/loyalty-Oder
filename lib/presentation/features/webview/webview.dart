// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// import '../../../config/config.dart';
// import '../../widgets/widgets.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (Platform.isAndroid) {
//     await InAppWebViewController.setWebContentsDebuggingEnabled(true);
//   }
// }

// class WebView extends StatefulWidget {
//   final Function? changeView;
//   final String url;

//   const WebView({super.key, this.changeView, required this.url});

//   @override
//   // ignore: no_logic_in_create_state
//   State<WebView> createState() => _WebViewState(settingUrl: url);
// }

// class _WebViewState extends State<WebView> {
//   String settingUrl;
//   final GlobalKey webViewKey = GlobalKey();
//   String url = "";
//   bool isLoading = false;

//   _WebViewState({required this.settingUrl});

//   late InAppWebViewController webViewController;
//   InAppWebViewSettings settings = InAppWebViewSettings(
//     supportZoom: false,
//     disableHorizontalScroll: true,
//     minimumFontSize: 16,
//     mediaPlaybackRequiresUserGesture: false,
//     useHybridComposition: true,
//     allowsInlineMediaPlayback: true,
//   );

//   late PullToRefreshController pullToRefreshController;
//   double progress = 0;
//   late Uint8List screenshotBytes;

//   @override
//   void initState() {
//     super.initState();

//     pullToRefreshController = PullToRefreshController(
//       settings: PullToRefreshSettings(color: colorMulberry),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController.reload();
//         } else if (Platform.isIOS) {
//           webViewController.loadUrl(
//             urlRequest: URLRequest(url: await webViewController.getUrl()),
//           );
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         InAppWebView(
//           key: webViewKey,
//           initialUrlRequest: URLRequest(url: WebUri(settingUrl)),
//           initialSettings: settings,
//           pullToRefreshController: pullToRefreshController,
//           onWebViewCreated: (controller) {
//             webViewController = controller;
//           },
//           onLoadStart: (controller, url) {
//             setState(() {
//               this.url = url.toString();
//             });
//           },
//           onPermissionRequest: (controller, request) async {
//             return PermissionResponse(
//               resources: request.resources,
//               action: PermissionResponseAction.GRANT,
//             );
//           },
//           onLoadStop: (controller, url) async {
//             pullToRefreshController.endRefreshing();
//             setState(() {
//               this.url = url.toString();
//               isLoading = false;
//             });
//           },
//           onReceivedError: (controller, request, error) {
//             pullToRefreshController.endRefreshing();
//           },
//           onProgressChanged: (controller, progress) {
//             if (progress == 100) {
//               pullToRefreshController.endRefreshing();
//             }
//             setState(() {
//               this.progress = progress / 100;
//               // urlController.text = this.url;
//             });
//           },
//           onUpdateVisitedHistory: (controller, url, androidIsReload) {
//             setState(() {
//               this.url = url.toString();
//             });
//           },
//           onConsoleMessage: (controller, consoleMessage) {},
//         ),
//         Container(
//           // height: MediaQuery.of(context).size.height,
//           color: colorBackground,
//           child: isLoading ? const LoadingWidget() : const SizedBox(),
//         ),
//       ],
//     );
//   }
// }
