// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:learning/app_routes.dart';

import 'dynamic_link.dart';
import 'firebase_options.dart';
import 'my_app.dart';
import 'notification.dart';

// the navigator key added to material app
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// this id for local notification
int id = 0;
String notificationId = "0";
String notificationType = "";

///Cloud messaging step 1
FirebaseMessaging messaging = FirebaseMessaging.instance;
// handling firebase background notification
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "Handling a background message: notificationn  ${message.notification?.title}");
}

bool isWithNotification = false;

/// flutter local notification
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Firebase Message settings //////

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
//// الحتة دي مهمة جداااااااا
  //// WHEN APP IS KILLED (NOT IN BACK GROUND) ///////////
  // when app recieve a message
  if (initialMessage != null) {
//  change isWithNotification to true
    isWithNotification = true;
//    set notificationType and notificationId from message
    notificationType = initialMessage.data['type'] ?? "";
    notificationId = initialMessage.data['id'] ?? "-1";
  }
// the data will be like this
/*
 {
    "message": {
        "token": "d3h7CB28T0CmD_ocRozVF9:APA91bFXLglA_9Pzn4-pKi9uh9v4uZeLXX3H2smHsIGB57r-uo61ITlwdqyqZxrtGTlKImBWBare9g1YrmtR1-GbFyiz8hroYr9eH6Xme-RPWb432IrXq7FGdPz9FMg2XQHPgSkFUeQn",
        "notification": {
            "body": "This is an FCM notification message!",
            "title": "FCM Message new"
        },
        "data": {
            "id": "2121",
            "type": "trip"
        }
    }
}
 */

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // we can check a notification data and go to the notification screen or trip details screen or product details screen
    navigatorKey.currentState?.pushNamed(Routes.notificationRoute);
  });

  ///Cloud messaging step 2
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // firebase notification if app is opened
  FirebaseMessaging.onMessage.listen((event) {
    print('on messageee${event.notification!.body!.toString()}');
    print('on messageee data ${event.data.toString()}');
    // show local notification
    showNotification(
        body: event.notification!.body!,
        title: event.notification!.title,
        payload: event.data.toString());
  });

//*************** local nottification settings  for android and IOS ************//

// don't forget to add the app icon image to "android\app\src\main\res\drawable\app_icon.png"
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  DarwinInitializationSettings initializationSettingsIOS =
      const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
// هنا بنقوله لما تضغط علي الاشعار حتعمل ايه
    onDidReceiveNotificationResponse: (NotificationResponse details) async {
      // we can check a notification data and go to the notification screen or trip details screen or product details screen
      // from details.payload it is = message.data = { "id": "2121", "type": "trip" }
      navigatorKey.currentState?.pushNamed(Routes.notificationRoute);

      print('dddddddddddddddddddddddd');
      print(details.payload.toString());
    },
  );

  if (Platform.isAndroid) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }
  if (Platform.isIOS) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  getToken();
// pass our parameters to the screen
  // runApp(MyApp(
  //   withNotification: isWithNotification,
  //   notificationId: notificationId,
  //   notificationtype: notificationType,
  // ));
  runApp(
    MaterialApp(
      title: 'Dynamic Links Example',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => MainScreen(),
         '/notification': (BuildContext context) => NotificationScreen(),
        '/H3Ed': (BuildContext context) =>
            DynamicLinkScreen(), // ده اللينك اللي علي فاير بيز
      },
    ),
  );
}

///Cloud messaging step 3
//token used for identify user in databse
getToken() async {
  String? token = await messaging.getToken();
  print("token =  $token");
  // messaging.deleteToken();
//  Preferences.instance.setNotificationToken(value: token ?? '');
  return token;
}

// show local notification when app is in forground
Future<void> showNotification(
    {required String body, title, String? payload}) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'app_icon',
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, title, body, notificationDetails, payload: payload);
}
