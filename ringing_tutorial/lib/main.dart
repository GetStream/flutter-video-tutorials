// ignore: dangling_library_doc_comments
/// Sample app for the Stream Ringing tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and push notification integration for ringing. To run it
/// locally, replace the placeholders in `lib/app_keys.dart` with your own
/// values:
/// - Stream API key
/// - iOS and Android push provider names
/// - Demo users' IDs, names, and tokens
///
/// You can obtain guidance and demo credentials from the tutorial page:
/// https://getstream.io/video/sdk/flutter/tutorial/ringing/
///
/// After updating the keys and users, build and run the app on a device.
import 'package:flutter/material.dart';
import 'package:ringing_tutorial/app_initializer.dart';
import 'package:ringing_tutorial/home_screen.dart';
import 'package:ringing_tutorial/login_screen.dart';
import 'package:ringing_tutorial/tutorial_user.dart';

TutorialUser? storedUser;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  storedUser = await AppInitializer.getStoredUser();

  if (storedUser != null) {
    await AppInitializer.init(storedUser!);
  }

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({
    super.key,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: storedUser == null ? LoginScreen() : HomeScreen(),
    );
  }
}
