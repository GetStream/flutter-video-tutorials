// ignore: dangling_library_doc_comments
/// Sample app for the Stream Ringing tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and push notification integration for ringing. To run it
/// locally, create `env/env.json` with your own values:
/// - Stream API key
/// - iOS and Android push provider names
/// - Demo users' tokens
///
/// See the README for how to create it and for the Firebase setup. You can
/// obtain guidance from the tutorial page:
/// https://getstream.io/video/sdk/flutter/tutorial/ringing/
///
/// After creating `env/env.json`, build and run the app on a device.
import 'package:flutter/material.dart';
import 'package:ringing_tutorial/app_initializer.dart';
import 'package:ringing_tutorial/app_keys.dart';
import 'package:ringing_tutorial/env_setup.dart';
import 'package:ringing_tutorial/home_screen.dart';
import 'package:ringing_tutorial/login_screen.dart';
import 'package:ringing_tutorial/tutorial_user.dart';

TutorialUser? storedUser;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppKeys.load();
  final missingEnvKeys = AppKeys.missingEnvKeys;
  if (missingEnvKeys.isNotEmpty) {
    runApp(MissingEnvApp(missingKeys: missingEnvKeys));
    return;
  }

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
