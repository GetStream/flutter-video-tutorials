// ignore: dangling_library_doc_comments
/// Sample app for the Stream Audio Room tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and usage. It reads your Stream API key and user tokens from
/// `env/env.json`, see the README for how to create it.
///
/// After creating `env/env.json`, run the app on a device or emulator.
import 'package:flutter/material.dart';
import 'package:audioroom_tutorial/app_keys.dart';
import 'package:audioroom_tutorial/env_setup.dart';
import 'package:audioroom_tutorial/login_screen.dart';

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();

  await AppKeys.load();
  final missingEnvKeys = AppKeys.missingEnvKeys;
  if (missingEnvKeys.isNotEmpty) {
    runApp(MissingEnvApp(missingKeys: missingEnvKeys));
    return;
  }

  runApp(
    const MaterialApp(
      home: LoginScreen(),
    ),
  );
}
