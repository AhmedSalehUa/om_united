import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';


class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  //
  // NotificationDetails? platformChannelSpecifics;

  Future<String> initNotificattions() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();

    NotificationSettings settings = await FirebaseMessaging.instance
        .requestPermission(
            alert: true,
            announcement: true,
            badge: true,
            carPlay: true,
            criticalAlert: true,
            provisional: true,
            sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("granted");
    }
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    print(fCMToken);

    return fCMToken!.isEmpty ? "" : fCMToken;
  }

  // void configNotifications() {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'high_importance_channel',
  //     'channel_name',
  //     importance: Importance.max,
  //     priority: Priority.max,
  //     channelDescription: 'channel_description',
  //     playSound: true,
  //     enableVibration: true,
  //     enableLights: true,
  //     color: Colors.blue,
  //     ledColor: Colors.white,
  //     ledOnMs: 1000,
  //     ledOffMs: 500,
  //     ticker: 'ticker_text',
  //     visibility: NotificationVisibility.public,
  //   );
  //   platformChannelSpecifics =
  //       const NotificationDetails(android: androidPlatformChannelSpecifics);
  // }
  //
  // Future<void> handleFCMessage(RemoteMessage message, String from) async {
  //   try {
  //     print('Handling a background message: ${message!.messageId}');
  //     print(" title :${message!.notification?.title}");
  //     print(" body :${message!.notification?.body}");
  //     print(" data :${message!.data}");
  //     print(" from :${from}");
  //   } catch (e) {
  //     print("object");
  //     print(e);
  //   }
  // }
}
