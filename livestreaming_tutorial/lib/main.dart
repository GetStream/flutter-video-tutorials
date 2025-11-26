// ignore: dangling_library_doc_comments
/// Sample app for the Stream Livestreaming tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and usage. You can test it with demo credentials or replace them with your own
///
/// After updating the values below, run the app on a device or emulator.
import 'package:flutter/material.dart';
import 'package:livestreaming_tutorial/login_screen.dart';
import 'package:livestreaming_tutorial/tutorial_user.dart';

TutorialUser? storedUser;

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();
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
