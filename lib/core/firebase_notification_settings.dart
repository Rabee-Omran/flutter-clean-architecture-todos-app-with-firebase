import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../injection_container.dart';
import 'notification_settings.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class FirebaseNotificationService {
  static final FirebaseNotificationService _firebasenotificationService =
      FirebaseNotificationService._internal();

  factory FirebaseNotificationService() {
    return _firebasenotificationService;
  }

  FirebaseNotificationService._internal();

  Future<void> init() async {
    final _messaging = sl<FirebaseMessaging>();
    final _localNotificationService = sl<NotificationService>();

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
        _localNotificationService.showNotifications(
            notification.title!, notification.body!);
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // PushNotification notification = PushNotification(
        //   title: message.notification?.title ?? "",
        //   body: message.notification?.body ?? "",
        // );
      });
      checkForInitialMessage();
    } else {
      print('User declined or has not accepted permission');
    }
  }

  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // PushNotification notification = PushNotification(
      //   title: initialMessage.notification?.title,
      //   body: initialMessage.notification?.body,
      // );
    }
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}
