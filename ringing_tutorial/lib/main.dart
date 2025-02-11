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
