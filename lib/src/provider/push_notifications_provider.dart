
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsProvider {
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  //PushNotificationsProvider? pushNotificationsProvider;

  void initNotifications() async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
    const AndroidInitializationSettings('launch_background');
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin?.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMessageListener() {
    // SEGUNDO PLANO
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
         print('NUEVA NOTIFICACION: ${message.data}');
        // Navigator.pushNamed(context, '/message',
        //   arguments: MessageArgument(message, true));

      }
    });

    //RECIBIR NOTIFICACIONES EN PRIMER PLANO
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null /*&& !kIsWeb*/) {
        flutterLocalNotificationsPlugin?.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    //Para recibir notificaciones en primer plano
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });
  }

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Permiso de notificación: ${settings.authorizationStatus}');
  }
}