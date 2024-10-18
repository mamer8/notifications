import 'package:flutter/material.dart';
import 'package:learning/product_details.dart';
import 'package:learning/splash.dart';
import 'package:learning/trip_details.dart';

import 'app_routes.dart';
import 'main.dart';
import 'notification.dart';

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,
      required this.withNotification,
      required this.notificationId,
      required this.notificationtype});
  final bool withNotification;
  final String notificationId;
  final String notificationtype;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: AppRoutes.onGenerateRoute,
      routes: {
        '/': (context) =>
        
        // first check if there is a notification

        
         withNotification
         // if there is a notification, check if it is a trip or product
            ? notificationtype == "trip"
                ? TripDetailsScreen(id: notificationId)
                : notificationtype == "product"
                    ? ProductDetailsScreen(id: notificationId)
                    :                    
                    // if it is not a trip or product, go to the notification screen
                     const NotificationScreen()
                     // if there is no notification, go to the splash screen
            : const SplashScreen(),
      },
      initialRoute: '/',
    );
  }
}
