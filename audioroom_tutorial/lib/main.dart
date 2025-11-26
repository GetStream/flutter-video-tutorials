// ignore: dangling_library_doc_comments
/// Sample app for the Stream Audio Room tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and usage. You can test it with demo credentials or replace them with your own
///
/// After updating the values below, run the app on a device or emulator.
import 'package:flutter/material.dart';
import 'package:audioroom_tutorial/login_screen.dart';

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      home: LoginScreen(),
    ),
  );
}
