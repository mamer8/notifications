import 'package:flutter/material.dart';

import 'app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen
({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
   void navigateToHome() async {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, Routes.homeRoute);
      },
    );
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigateToHome();
  }

  @override
    Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Splaash screen'),
      ),
      body: Center(
        child: Text(
          'Splaash screen',
        ),
      ),
    );
  }
}