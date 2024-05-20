// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
int id = 0;

///Cloud messaging step 1
final navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(channel.id, channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        icon: '@mipmap-mdpi/ic_launcher'));

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print(
      "Handling a background message: notificationn  ${message.notification.toString()}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  FirebaseMessaging.onMessage.listen((event) {
    print(
        'on messsssssssssssdddssageeeeeeee${event.notification!.body!.toString()}');
    showNotification(
        body: event.notification!.body!, title: event.notification!.title);
  });

  // Handle the onMessageOpenedApp event
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
   // navigatorKey.currentState?.pushNamed(Routes.notifications);
  });

  /////////////////

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
// هنا بنقوله لما توصلك الاشعارات حتعمل ايه
    onDidReceiveNotificationResponse: (NotificationResponse details) async {
   //   navigatorKey.currentState?.pushNamed(Routes.notifications);

      print('dddddddddddddddddddddddd');
      print(details.toString());
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

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  /////////////////
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  getToken();

// await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//   alert: true,
//   badge: true,
//   sound: true,
// );
  //var token = await FirebaseMessaging.instance.getToken();

  //print('ttttttttttttttttttttttttt ${token.toString()}');
  runApp(
    MyApp()
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
        
        child:  Text(
              'You have pushed the button this many times:',
            ),
      ),
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}



Future<void> showNotification({required String body, title}) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(id++, title, body, notificationDetails, payload: 'item x');
}

///Cloud messaging step 3
///token used for identify user in databse
getToken() async {
  String? token = await messaging.getToken();
  print("token =  $token");

//  Preferences.instance.setNotificationToken(value: token ?? '');
  return token;
}



AndroidNotificationChannel channel = AndroidNotificationChannel(
'high notiSound',"high_importance_channel_elm3"
);
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






