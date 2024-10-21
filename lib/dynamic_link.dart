import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? _linkMessage;
  bool _isCreatingLink = false;

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final String _testString =
      'To test: long press link and then copy and click from a non-browser '
      "app. Make sure this isn't being tested on iOS simulator and iOS xcode "
      'is properly setup. Look at firebase_dynamic_links/README.md for more '
      'details.';

  final String DynamicLink = 'https://amerlearningapp.page.link/H3Ed';
  final String Link = 'https://amerlearningapp.page.link/H3Ed';
  // final String Link = 'https://flutterfiretests.page.link/MEGs';

  @override
  void initState() {
    super.initState();
    initDynamicLink();
  }

  Future<void> _createDynamicLink(bool short) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://amerlearningapp.page.link/H3Ed',
      // uriPrefix: 'https://flutterfiretests.page.link',
      longDynamicLink: Uri.parse(
        'https://flutterfiretests.page.link?efr=0&ibi=io.flutter.plugins.firebase.dynamiclinksexample&apn=io.flutter.plugins.firebase.dynamiclinksexample&imv=0&amv=0&link=https%3A%2F%2Fexample%2Fhelloworld&ofl=https://ofl-example.com',
      ),
      link: Uri.parse(DynamicLink),
      androidParameters: const AndroidParameters(
        packageName: 'io.flutter.plugins.firebase.dynamiclinksexample',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'io.flutter.plugins.firebase.dynamiclinksexample',
        minimumVersion: '0',
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
  }
///// importaaaaaannnnnnnnttt neeehhaaaallll
  void initDynamicLink() async {
    print("fff");
    // Handle dynamic links if the app was opened with one
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? initialDeepLink = initialLink?.link;
    if (initialDeepLink != null) {
      print('Initial dynamic link: ${initialDeepLink.toString()}');
      print('Initial dynamic path: ${initialDeepLink.path.toString()}');
       // ignore: use_build_context_synchronously
       Navigator.pushNamed(context, initialDeepLink.path);
    }

    // Listen for dynamic links while the app is running
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData dynamicLink) {
      final Uri? deepLink = dynamicLink.link;
      print("dddd ${deepLink}");
      if (deepLink != null) {
        // Handle the dynamic link
        print('Dynamic Link: ${deepLink.toString()}');
      }
    }).onError((error) {
      print('Error handling dynamic link: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dynamic Links Example'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          print("ffffffffff");

                          final PendingDynamicLinkData? data =
                              await dynamicLinks.getInitialLink();
                          final Uri? deepLink = data?.link;
                          print("ggggggggg ${deepLink}");
                          if (deepLink != null) {
                            // ignore: unawaited_futures
                            Navigator.pushNamed(context, deepLink.path);
                          }
                        },
                        child: const Text('getInitialLink'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final PendingDynamicLinkData? data =
                              await dynamicLinks
                                  .getDynamicLink(Uri.parse(Link));
                          final Uri? deepLink = data?.link;
                          print("ggggggggg ${deepLink}");

                          if (deepLink != null) {
                            // ignore: unawaited_futures
                            Navigator.pushNamed(context, deepLink.path);
                          }
                        },
                        child: const Text('getDynamicLink'),
                      ),
                      ElevatedButton(
                        onPressed: !_isCreatingLink
                            ? () => _createDynamicLink(false)
                            : null,
                        child: const Text('Get Long Link'),
                      ),
                      ElevatedButton(
                        onPressed: !_isCreatingLink
                            ? () => _createDynamicLink(true)
                            : null,
                        child: const Text('Get Short Link'),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      print("fffffff ${_linkMessage}");
                      if (_linkMessage != null) {
                        await launchUrl(Uri.parse(_linkMessage!));
                      }
                    },
                    onLongPress: () {
                      if (_linkMessage != null) {
                        Clipboard.setData(ClipboardData(text: _linkMessage!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied Link!')),
                        );
                      }
                    },
                    child: Text(
                      _linkMessage ?? '',
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  Text(_linkMessage == null ? '' : _testString),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class DynamicLinkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World DeepLink'),
        ),
        body: const Center(
          child: Text('Hello, World!'),
        ),
      ),
    );
  }
}
