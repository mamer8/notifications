import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    
    super.initState();
    //initDynamicLink();
  }

  // void initDynamicLink() async {
  //   print("fff");
  //   // Handle dynamic links if the app was opened with one
  //   final PendingDynamicLinkData? initialLink =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri? initialDeepLink = initialLink?.link;
  //   print('Initiallll link: ${initialLink.toString()}');
  //   if (initialDeepLink != null) {
  //     print('Initial dynamic link: ${initialDeepLink.toString()}');
  //     print('Initial dynamic path: ${initialDeepLink.path.toString()}');

  //     if (initialDeepLink.toString().contains("product")) {
  //       Uri uri = Uri.parse(initialDeepLink.toString());
  //       String id = uri.queryParameters['id'] ?? "-1";

  //       Navigator.pushNamed(context, initialDeepLink.path, arguments: id);
  //     } else {
  //       Navigator.pushNamed(context, initialDeepLink.path);
  //     }
  //   }

  //   // Listen for dynamic links while the app is running
  //   FirebaseDynamicLinks.instance.onLink
  //       .listen((PendingDynamicLinkData dynamicLink) {
  //     final Uri? deepLink = dynamicLink.link;
  //     print("dddd ${deepLink}");
  //     if (deepLink != null) {
  //       // Handle the dynamic link
  //       print('Dynamic Link: ${deepLink.toString()}');
  //     }
  //   }).onError((error) {
  //     print('Error handling dynamic link: $error');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Home Page",
        ),
      ),
    );
  }
}
