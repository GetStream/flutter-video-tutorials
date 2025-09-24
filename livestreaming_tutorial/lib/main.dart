// ignore: dangling_library_doc_comments
/// Sample app for the Stream Livestreaming tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and usage. You can test it with demo credentials or replace them with your own
///
/// After updating the values below, run the app on a device or emulator.
import 'package:flutter/material.dart';
import 'package:livestreaming_tutorial/home_screen.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();

  /// Replace the values below with your own Stream API keys and sample user data if you want to test your Stream app.
  /// For development, you can generate user tokens with our online tool: https://getstream.io/chat/docs/flutter-dart/tokens_and_authentication/#manually-generating-tokens
  /// For production apps, generate tokens on your server rather than in the client.
  StreamVideo(
    'mmhfdzb5evj2',
    user: const User(
      info: UserInfo(
        name: 'Alice Johnson',
        id: 'alice_johnson',
        role: 'admin',
      ),
    ),
    userToken:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWxpY2Vfam9obnNvbiJ9.v6-yXWgbLyykj9yt_ophmaC5FCGAG9ic6p02V09CmKQ',
  );

  runApp(
    const MaterialApp(
      home: HomeScreen(),
    ),
  );
}
