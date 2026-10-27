// ignore: dangling_library_doc_comments
/// Sample app for the Stream Livestreaming tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and usage. It reads your Stream API key and user tokens from
/// `env/env.json`, see the README for how to create it.
///
/// After creating `env/env.json`, run the app on a device or emulator.
import 'package:flutter/material.dart';
import 'package:livestreaming_tutorial/app_keys.dart';
import 'package:livestreaming_tutorial/env_setup.dart';
import 'package:livestreaming_tutorial/login_screen.dart';
import 'package:livestreaming_tutorial/tutorial_user.dart';

TutorialUser? storedUser;

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();

  await AppKeys.load();
  final missingEnvKeys = AppKeys.missingEnvKeys;
  if (missingEnvKeys.isNotEmpty) {
    runApp(MissingEnvApp(missingKeys: missingEnvKeys));
    return;
  }

  runApp(const MainApp());
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
    return const MaterialApp(
      home: LoginScreen(),
    );
  }
}
