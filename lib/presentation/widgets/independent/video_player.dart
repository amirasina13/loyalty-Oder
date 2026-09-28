import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../app_setting/app_setting.dart';

class VideoPlayerApp extends StatefulWidget {
  final String? videoUrl;
  const VideoPlayerApp({super.key, this.videoUrl});

  @override
  State<StatefulWidget> createState() => VideoPlayerAppState();
}

class VideoPlayerAppState extends State<VideoPlayerApp>
    with WidgetsBindingObserver {
  bool _isLoading = true; // State to track loading status
  // late WebViewController? _controller;
  final bool _showReplayButton = false;
  String typeURL = '';
  // late VideoPlayerController videoPlayerController;
  // var yt = YoutubeExplode();
  // String newuRL = '';
  // String videoId = '';
  // late YoutubePlayerController youtubeController;
  late InAppWebViewController webViewController;
  final GlobalKey webViewKey = GlobalKey();
  PullToRefreshController? pullToRefreshController;
  late ContextMenu contextMenu;

  // InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "autoplay; fullscreen;",
    iframeAllowFullscreen: true,
    allowBackgroundAudioPlaying: false,
    javaScriptEnabled: true,
  );

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
      menuItems: [
        ContextMenuItem(
          id: 1,
          title: "Special",
          action: () async {
            // print("Menu item Special clicked!");
            // print(await webViewController?.getSelectedText());
            await webViewController.clearFocus();
          },
        ),
      ],
      settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
      onCreateContextMenu: (hitTestResult) async {},
      onHideContextMenu: () {
        // print("onHideContextMenu");
      },
      onContextMenuActionItemClicked: (contextMenuItemClicked) async {
        // var id = contextMenuItemClicked.id;
        // print("onContextMenuActionItemClicked: " +
        //     id.toString() +
        //     " " +
        //     contextMenuItemClicked.title);
      },
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
                  webViewController.reload();
                } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                  webViewController.loadUrl(
                    urlRequest: URLRequest(
                      url: await webViewController.getUrl(),
                    ),
                  );
                }
              },
            );
  }

  void stopVideo() {
    // ignore: unnecessary_null_comparison
    if (webViewController != null) {
      webViewController.stopLoading();
      // Or you can use JavaScript to pause the video
      webViewController.evaluateJavascript(
        source: "document.querySelector('video').pause();",
      );
      // You might also need to stop the audio specifically
      webViewController.evaluateJavascript(
        source: "document.querySelector('video').muted = true;",
      );
    }
  }

  @override
  Future<void> dispose() async {
    // ignore: unnecessary_null_comparison
    if (webViewController != null) {
      try {
        await webViewController.loadUrl(
          urlRequest: URLRequest(url: WebUri('about:blank')),
        );
      } catch (e) {
        // print('--- Error during final loadUrl(): $e ---');
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1 / 1,
      child: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(
              url: WebUri(
                widget.videoUrl!.contains('facebook.com')
                    ? "${widget.videoUrl} + &height=520"
                    : widget.videoUrl!,
              ),
            ),
            initialSettings: settings,
            contextMenu: contextMenu,
            pullToRefreshController: pullToRefreshController,
            onWebViewCreated: (controller) async {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;

                if (url.toString().contains('instagram.com')) {
                  typeURL = 'instagram';
                } else if (url.toString().contains('facebook.com')) {
                  typeURL = 'facebook';
                } else if (url.toString().contains('youtube.com')) {
                  typeURL = 'youtube';
                }
              });
            },
            onPermissionRequest: (controller, request) async {
              return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT,
              );
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url;

              if (uri == null) {
                return NavigationActionPolicy.CANCEL;
              }

              final url = uri.toString();

              // ✅ Allow embedded YouTube (or Facebook/Instagram) URLs
              if (url.contains("youtube.com/embed") ||
                  url.contains("facebook.com") ||
                  url.contains("instagram.com")) {
                return NavigationActionPolicy.ALLOW;
              }

              // ❌ Block any attempt to open YouTube's main page or ads
              return NavigationActionPolicy.CANCEL;
            },

            onLoadStop: (controller, url) {
              pullToRefreshController?.endRefreshing();
              setState(() {
                _isLoading = false;
              });
            },
            onReceivedError: (controller, request, error) {
              pullToRefreshController?.endRefreshing();
            },

            onConsoleMessage: (controller, consoleMessage) {
              // print(consoleMessage);
            },
          ),
          if (_isLoading)
            Container(
              color: colorBlack.withValues(alpha: 0.5),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Loading video...',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        color: colorSoftGrey,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 8),
                    CircularProgressIndicator(
                      color: colorSoftGrey.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          if (_showReplayButton)
            Positioned(
              bottom: 16,
              right: 16,
              child: SizedBox(
                height: 50,
                width: 50,
                child: FloatingActionButton(
                  backgroundColor: colorBlack.withValues(alpha: 0.5),
                  onPressed: () {
                    // Reload the video by reloading the URL
                    webViewController.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri(
                          widget.videoUrl!.contains('facebook.com')
                              ? "${widget.videoUrl} + &height=520"
                              : widget.videoUrl!,
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.replay),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // @override
  // void dispose() {
  //   // _controller?.runJavascript("document.querySelector('video').pause();");
  //   super.dispose();
  // }
}
