// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';

// the navigator key added to material app
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// this id for local notification
int id = 0;

///Cloud messaging step 1
FirebaseMessaging messaging = FirebaseMessaging.instance;
// handling firebase background notification
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "Handling a background message: notificationn  ${message.notification?.title}");
}

/// flutter local notification
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Firebase Message settings //////

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

  // Handle the onMessageOpenedApp event
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('onMessageOpenedApp data ${message.data.toString()}');
    print('onMessageOpenedApp route ${message.data['route']}');

    // navigatorKey.currentState?.pushNamed(Routes.notifications);
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
      //   navigatorKey.currentState?.pushNamed(Routes.notifications);

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

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // add navigator key
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'You have pushed the button this many times:',
        ),
      ),
    );
  }
}

///Cloud messaging step 3
//token used for identify user in databse
getToken() async {
  String? token = await messaging.getToken();
  print("token =  $token");

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

// AndroidNotificationChannel channel = AndroidNotificationChannel(
// 'high notiSound',"high_importance_channel_elm3"
// );
// AndroidNotificationChannel channel = AndroidNotificationChannel(
// Preferences.instance.notiSound
//     ? Preferences.instance.notiVisbrate
//         ? Preferences.instance.notiLight
//             ? 'high notiVisbrate'
//             : 'high notiLight'
//         : 'high notiSound'
//     : "high notielse", // id
// Preferences.instance.notiSound
//     ? Preferences.instance.notiVisbrate
//         ? Preferences.instance.notiLight
//             ? 'high_notiVisbrateTitle'
//             : 'high_notiLightTitle'
//         : 'high_notiSoundTitle'
//     : "high_importance_channel_elm3", // title
// description: "this notification tarek tube",
// importance: Importance.high,
// enableVibration: Preferences.instance.notiVisbrate,
// playSound: Preferences.instance.notiSound,
//  enableLights: Preferences.instance.notiLight,
// );
