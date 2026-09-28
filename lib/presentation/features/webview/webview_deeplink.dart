import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../app_setting/app_setting.dart';
import '../../../locator.dart';
import '../../navigation_service.dart';
import '../../widgets/widgets.dart';
import '../authentication/authentication_bloc.dart';
import '../authentication/authentication_event.dart';
import '../register/register_screen.dart';
import '../rewards/reward_detail.dart';

class TempData {
  static String voucherId = '';
  static String voucherRefCode = '';
  static String affiliateCode = '';
  static String currentPage = '';
  static String action = '';
  // static String url = '';
  static String deeplink = '';
  // static bool deeplinkDone = false;
}

class DeeplinkParameters {
  final String initialUrl;

  const DeeplinkParameters({required this.initialUrl});
}

class RedirectWebView extends StatefulWidget {
  final DeeplinkParameters parameters;

  const RedirectWebView({super.key, required this.parameters});

  @override
  RedirectWebViewState createState() => RedirectWebViewState();
}

class RedirectWebViewState extends State<RedirectWebView> {
  late final WebViewController _controller;
  bool _isProcessed = false;
  // ignore: unused_field
  bool _shouldLoadContent = true;
  // bool _isReferralActionCompleted = false;
  // bool _isVoucherActionCompleted = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0x00000000))
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (progress) {},
              onPageStarted: (url) {
                debugPrint('onPageStarted: $url');
              },
              onPageFinished: (url) {
                debugPrint('onPageFinished: $url');
                Storage().setupDone = null;
                setState(() => isLoading = false);
              },
              onHttpError: (error) {},
              onWebResourceError: (error) => inspect(error),
              onNavigationRequest: _handleNavigationRequest,
              // onNavigationRequest: (request) {
              //   final uri = Uri.parse(request.url);
              //   debugPrint('onNavigationRequest: ${request.url}');

              //   if (!_isProcessed && uri.queryParameters.containsKey('c')) {
              //     _isProcessed = true;
              //     _shouldLoadContent = false;

              //     try {
              //       final decodeResponse = decodeArray(
              //         uri.queryParameters['c'].toString(),
              //       );

              //       var action = decodeResponse['action'] ?? "";
              //       var affiliate = decodeResponse['affiliate'] ?? "";
              //       var voucherId = decodeResponse['id'] ?? "";
              //       var voucherRefCode = decodeResponse['refer'] ?? "";
              //       var token = Storage().token;
              //       TempData.action = action;

              //       if (mounted) {
              //         if (action == 'referral') {
              //           if (token.isNotEmpty) {
              //             Storage().token = '';
              //             Storage().welcomeSplash = '';
              //             BlocProvider.of<AuthenticationBloc>(
              //               context,
              //             ).add(AuthenticationLoggedOut());
              //           }

              //           sl<NavigationService>().navigatorKey.currentState
              //               ?.pushNamedAndRemoveUntil(
              //                 OderRoutes.register,
              //                 (route) => false,
              //                 arguments: RegisterParameters(
              //                   referralCode: affiliate,
              //                 ),
              //               );
              //           _isReferralActionCompleted = true;
              //           if (_isReferralActionCompleted) {
              //             action = '';
              //           }
              //         } else if (action == 'voucher') {
              //           TempData.voucherId = voucherId;
              //           TempData.voucherRefCode = voucherRefCode;
              //           TempData.currentPage = 'voucherPage';

              //           if (token.isEmpty) {
              //             sl<NavigationService>().navigatorKey.currentState
              //                 ?.pushNamedAndRemoveUntil(
              //                   OderRoutes.login,
              //                   (route) => false,
              //                 );
              //           } else {
              //             Navigator.of(context).pushNamed(
              //               OderRoutes.rewardDetails,
              //               arguments: RewardDetailsParameters(
              //                 rewardId: voucherId,
              //                 title: '',
              //                 indexPage: 3,
              //               ),
              //             );
              //           }

              //           _isVoucherActionCompleted = true;
              //           if (_isVoucherActionCompleted) {
              //             action = '';
              //           }
              //         }
              //       }
              //     } catch (e) {
              //       debugPrint('Error during decoding: $e');
              //     }

              //     return NavigationDecision.prevent;
              //   }

              //   return NavigationDecision.navigate;
              // },
            ),
          )
          ..loadRequest(Uri.parse(widget.parameters.initialUrl));
  }

  NavigationDecision _handleNavigationRequest(NavigationRequest request) {
    final uri = Uri.tryParse(request.url);

    // Block non-HTTP/HTTPS schemes (e.g., file:, data:, javascript:)
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      debugPrint('Prevented unsafe scheme navigation: ${request.url}');
      if (mounted) setState(() => isLoading = false);
      return NavigationDecision.prevent;
    }

    // Decode and process app actions if parameter 'c' exists
    if (!_isProcessed && uri.queryParameters.containsKey('c')) {
      final rawActionData = uri.queryParameters['c'];
      if (rawActionData != null && rawActionData.isNotEmpty) {
        _processActionPayload(rawActionData);
      }

      // Prevent the WebView from rendering raw action payload links
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _processActionPayload(String rawPayload) {
    try {
      final decodeResponse = decodeArray(rawPayload);
      final action = decodeResponse['action'] ?? '';
      final affiliate = decodeResponse['affiliate'] ?? '';
      final voucherId = decodeResponse['id'] ?? '';
      final voucherRefCode = decodeResponse['refer'] ?? '';
      final token = Storage().token;

      TempData.action = action;
      if (!mounted) return;

      // Validate expected action types before taking state-altering actions
      if (action == 'referral') {
        _isProcessed = true;
        _shouldLoadContent = false;

        // final token = Storage().token;
        if (token.isNotEmpty) {
          Storage().clearSessionData();
          BlocProvider.of<AuthenticationBloc>(
            context,
          ).add(AuthenticationLoggedOut());
        }

        sl<NavigationService>().navigatorKey.currentState
            ?.pushNamedAndRemoveUntil(
              OderRoutes.register,
              (route) => false,
              arguments: RegisterParameters(referralCode: affiliate),
            );
      } else if (action == 'voucher') {
        _isProcessed = true;
        TempData.voucherId = voucherId;
        TempData.voucherRefCode = voucherRefCode;
        TempData.currentPage = 'voucherPage';
        // _isProcessed = true;
        // TempData.voucherId = decodeResponse['id'] ?? '';
        // TempData.voucherRefCode = decodeResponse['refer'] ?? '';

        if (token.isEmpty) {
          sl<NavigationService>().navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(OderRoutes.login, (route) => false);
        } else {
          Navigator.of(context).pushNamed(
            OderRoutes.rewardDetails,
            arguments: RewardDetailsParameters(
              rewardId: voucherId,
              title: '',
              indexPage: 3,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Failed to parse redirect action payload safely: $e');
    }
  }

  @override
  void dispose() {
    // Clean up WebView before Flutter engine shuts down
    try {
      _controller.clearCache(); // optional
      _controller.loadRequest(Uri.parse('about:blank'));
    } catch (_) {}

    // Nullify reference to prevent engine-channel calls
    // (helps prevent the crash seen on termination)
    super.dispose();
  }

  void clearWebview() {
    try {
      _controller.clearCache(); // optional
      _controller.loadRequest(Uri.parse('about:blank'));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          isLoading
              ? Container(
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
                child: LoadingWidget(backgroundColor: colorTransparent),
              )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Map<String, dynamic> decodeArray(String hexData) {
    try {
      Uint8List bytes = hexToBytes(hexData);
      String base64String = utf8.decode(bytes);
      Uint8List decodedBytes = base64.decode(base64String);
      String jsonString = utf8.decode(decodedBytes);
      return jsonDecode(jsonString);
    } catch (e) {
      // print('Error during decoding: $e');
      debugPrint('Error during decoding: $e');
      rethrow;
    }
  }

  Uint8List hexToBytes(String hex) {
    if (hex.length % 2 != 0) {
      throw FormatException('Hex string must have an even length');
    }

    final length = hex.length;
    final bytes = Uint8List(length ~/ 2);

    for (int i = 0; i < length; i += 2) {
      bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }

    return bytes;
  }
}
