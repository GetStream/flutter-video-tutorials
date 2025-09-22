// ignore: dangling_library_doc_comments
/// Sample app for the Stream Livestreaming tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and usage. To run it locally, replace the placeholders in
/// `main()` with your own credentials:
/// - API key
/// - User ID and token
///
/// You can obtain demo credentials from the tutorial page:
/// https://getstream.io/video/sdk/flutter/tutorial/livestreaming/
///
/// After updating the values below, run the app on a device or emulator.
import 'package:flutter/material.dart';
import 'package:livestreaming_tutorial/home_screen.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Replace the placeholders below with your API key, user ID, and user token.
  // Get demo credentials at: https://getstream.io/video/sdk/flutter/tutorial/livestreaming/
  // Initialize Stream video and set the API key for our app.
  StreamVideo(
    'REPLACE_WITH_API_KEY',
    user: const User(
      info: UserInfo(
        name: 'REPLACE_WITH_USER_NAME',
        id: 'REPLACE_WITH_USER_ID',
        role: 'admin',
      ),
    ),
    userToken: 'REPLACE_WITH_TOKEN',
  );

  runApp(
    const MaterialApp(
      home: HomeScreen(),
    ),
  );
}
