import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin _notiPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initialSettings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
    );
    _notiPlugin.initialize(initialSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) {
      print('onDidReceiveNotificationResponse Function');
      print(details.payload);
      print(details.payload != null);
    });
  }

  static void showNotification(RemoteMessage message) {
    const NotificationDetails notiDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'com.example.sonic_patti',
        'sonic_gmx_channel',
        importance: Importance.max,
        priority: Priority.high,
        //sound: RawResourceAndroidNotificationSound('alert'),
        enableVibration: true,
        playSound: true,
      ),
    );
    _notiPlugin.show(
      DateTime.now().microsecond,
      message.notification!.title,
      message.notification!.body,
      notiDetails,
      payload: message.data.toString(),
    );
  }
}