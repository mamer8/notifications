import 'package:flutter/material.dart';
import 'package:learning/product_details.dart';
import 'package:learning/splash.dart';
import 'package:learning/trip_details.dart';

import 'home.dart';
import 'notification.dart';

class Routes {
  static const String initialRoute = '/';

  static const String productDetailsRoute = '/productDetailsRoute';
  static const String notificationRoute = '/notificationRoute';
  static const String homeRoute = '/homeRoute';
  static const String  tripDetailsRoute = '/tripDetailsRoute';

  
}

class AppRoutes {
  static String route = '';

  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case Routes.homeRoute:
        return MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        );
      case Routes.notificationRoute:
        return MaterialPageRoute(
          builder: (context) => const NotificationScreen(),
        );
     
      case Routes.productDetailsRoute:
        String id = settings.arguments as String;

        return MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(
            id: id,
          ),
        );
      case Routes.tripDetailsRoute:
        String id = settings.arguments as String;

        return MaterialPageRoute(
          builder: (context) => TripDetailsScreen(
            id: id,
          ),
        );

      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(
          child: Text("noRouteFound"),
        ),
      ),
    );
  }
}
