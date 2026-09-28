// // background_handler.dart
// import 'package:firebase_messaging/firebase_messaging.dart';

// import '../presentation/features/notification/notification.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // await Firebase.initializeApp(); // Initialize if needed
//   print("Handling background message in separate file: ${message.messageId}");
//   await NotificationService.showBackgroundNotification(message);
// }

class TempDataNotification {
  static String notificationPage = '';
}
