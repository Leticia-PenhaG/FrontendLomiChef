
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lomi_chef_to_go/src/provider/user_provider.dart';
import 'package:googleapis_auth/auth_io.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
class PushNotificationsProvider {
  late AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

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

      if (notification != null && android != null) {
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
      } else if (message.data.isNotEmpty) {
        flutterLocalNotificationsPlugin?.show(
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
          message.data['title'],
          message.data['body'],
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

  //1
  void saveToken(User user, BuildContext context) async {
    String? token = await FirebaseMessaging.instance.getToken();
    UserProvider usersProvider = new UserProvider();
    usersProvider.init(context,sessionUser: user);
    usersProvider.updateNotificationToken(user.id!, token!);

  }

  Future<void> sendMessageFCMV1({
    required String fcmToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final accessToken = await getAccessTokenFromServiceAccount(); // Debes implementarlo

    final uri = Uri.parse('https://fcm.googleapis.com/v1/projects/fast-food-v2/messages:send');

    final messagePayload = {
      'message': {
        'token': fcmToken,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': data ?? {},
      }
    };

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(messagePayload),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  Future<String> getAccessTokenFromServiceAccount() async {
    // Carga el archivo de la cuenta de servicio
    //final serviceAccountJson = File('assets/credentials/service_account.json').readAsStringSync();
    final serviceAccountJson = await rootBundle.loadString('assets/credentials/service-account.json');

    final credentials = ServiceAccountCredentials.fromJson(serviceAccountJson);

    // Define los alcances requeridos para FCM v1
    const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    // Crea un cliente autenticado
    final client = await clientViaServiceAccount(credentials, scopes);

    // Extrae el access token
    final accessToken = client.credentials.accessToken.data;

    // Cierra el cliente después del uso
    client.close();

    return accessToken;
  }

  // Future<void> sendMessageFCMV1MultipleUsers({
  //   required List<String> fcmTokenList,
  //   required String title,
  //   required String body,
  //   Map<String, String>? data,
  // }) async {
  //   final accessToken = await getAccessTokenFromServiceAccount(); // Debes implementarlo
  //
  //   final uri = Uri.parse('https://fcm.googleapis.com/v1/projects/fast-food-v2/messages:send');
  //
  //   final messagePayload = {
  //     'message': {
  //       'token': fcmTokenList,
  //       'notification': {
  //         'title': title,
  //         'body': body,
  //       },
  //       'data': data ?? {},
  //       'registration_ids': fcmTokenList //lista de tokens a quienes se le enviará la notificación
  //     }
  //   };
  //
  //   final response = await http.post(
  //     uri,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //     body: jsonEncode(messagePayload),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Notification sent successfully');
  //   } else {
  //     print('Failed to send notification: ${response.body}');
  //   }
  // }

  // Future<void> sendMessageFCMV1MultipleUsers({
  //   required List<String> fcmTokenList,
  //   required String title,
  //   required String body,
  //   Map<String, String>? data,
  // }) async {
  //   final accessToken = await getAccessTokenFromServiceAccount();
  //
  //   for (String token in fcmTokenList) {
  //     final uri = Uri.parse('https://fcm.googleapis.com/v1/projects/fast-food-v2/messages:send');
  //
  //     final messagePayload = {
  //       'message': {
  //         'token': token,
  //         'notification': {
  //           'title': title,
  //           'body': body,
  //         },
  //         'data': data ?? {},
  //       }
  //     };
  //
  //     final response = await http.post(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $accessToken',
  //       },
  //       body: jsonEncode(messagePayload),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Notification sent successfully to $token');
  //     } else {
  //       print('Failed to send notification to $token: ${response.body}');
  //     }
  //   }
  // }

  Future<void> sendMessageFCMV1MultipleUsers({
    required List<String> fcmTokenList,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final accessToken = await getAccessTokenFromServiceAccount();

    for (String token in fcmTokenList) {
      final uri = Uri.parse('https://fcm.googleapis.com/v1/projects/fast-food-v2/messages:send');

      final messagePayload = {
        'message': {
          'token': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
        }
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(messagePayload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully to $token');
      } else {
        print('Failed to send to $token: ${response.body}');
      }
    }
  }

}