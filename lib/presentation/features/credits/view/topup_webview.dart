// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// import '../../../../config/config.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (Platform.isAndroid) {
//     await InAppWebViewController.setWebContentsDebuggingEnabled(true);
//   }
// }

// class TopupWebView extends StatefulWidget {
//   final Function? changeView;
//   final String? paymentUrl;

//   const TopupWebView({super.key, this.changeView, this.paymentUrl});

//   @override
//   // ignore: no_logic_in_create_state
//   State<TopupWebView> createState() => _TopupWebViewState(paymentUrl);
// }

// class _TopupWebViewState extends State<TopupWebView> {
//   // ignore: prefer_typing_uninitialized_variables
//   var url, paymentUrl;
//   final GlobalKey webViewKey = GlobalKey();

//   _TopupWebViewState(this.paymentUrl);

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
//       settings: PullToRefreshSettings(color: primaryColor),
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
//     return InAppWebView(
//       key: webViewKey,
//       initialUrlRequest: URLRequest(url: WebUri(paymentUrl)),
//       initialSettings: settings,
//       pullToRefreshController: pullToRefreshController,
//       onWebViewCreated: (controller) {
//         webViewController = controller;
//       },
//       onLoadStart: (controller, url) {
//         setState(() {
//           this.url = url.toString();
//         });
//       },
//       onPermissionRequest: (controller, request) async {
//         return PermissionResponse(
//           resources: request.resources,
//           action: PermissionResponseAction.GRANT,
//         );
//       },
//       shouldOverrideUrlLoading: (controller, navigationAction) async {
//         var uri = navigationAction.request.url;

//         if (![
//           "http",
//           "https",
//           "file",
//           "chrome",
//           "data",
//           "javascript",
//           "about",
//         ].contains(uri!.scheme)) {
//           // if (await canLaunch(url)) {
//           //   // Launch the App
//           //   await launch(
//           //     url,
//           //   );
//           //   // and cancel the request
//           //   return NavigationActionPolicy.CANCEL;
//           // }
//         }

//         return NavigationActionPolicy.ALLOW;
//       },
//       onLoadStop: (controller, url) async {
//         pullToRefreshController.endRefreshing();
//         setState(() {
//           this.url = url.toString();
//         });

//         // ignore: unused_local_variable
//         var result = await controller.evaluateJavascript(
//           source: "function print(key, params){};",
//         );
//       },
//       onReceivedError: (controller, request, error) {
//         pullToRefreshController.endRefreshing();
//       },
//       onProgressChanged: (controller, progress) {
//         if (progress == 100) {
//           pullToRefreshController.endRefreshing();
//         }
//         setState(() {
//           this.progress = progress / 100;
//         });
//       },
//       onUpdateVisitedHistory: (controller, url, androidIsReload) {
//         setState(() {
//           this.url = url.toString();
//         });
//       },
//       onConsoleMessage: (controller, consoleMessage) {},
//     );
//   }
// }
