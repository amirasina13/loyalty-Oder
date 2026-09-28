import Flutter
import UIKit
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    if let controller = window?.rootViewController as? FlutterViewController {
      let bundleId = Bundle.main.bundleIdentifier 
      let deepLinkChannel = FlutterMethodChannel(name: "deeplink_channel",
                                                 binaryMessenger: controller.binaryMessenger)

      deepLinkChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
        // Additional handling if needed
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
       let url = userActivity.webpageURL {
      if let controller = window?.rootViewController as? FlutterViewController {
        let bundleId = Bundle.main.bundleIdentifier 
        let deepLinkChannel = FlutterMethodChannel(name: "deeplink_channel",
                                                   binaryMessenger: controller.binaryMessenger)

        // Send the full Universal Link URL to Flutter
        deepLinkChannel.invokeMethod("getDeepLink", arguments: url.absoluteString)
      }
    }
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}
