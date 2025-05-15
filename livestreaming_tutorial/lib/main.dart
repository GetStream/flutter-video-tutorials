import 'package:flutter/material.dart';
import 'package:livestreaming_tutorial/home_screen.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: REPLACE CREDENTIALS
  // Get demo credentials from: https://getstream.io/video/sdk/flutter/tutorial/livestreaming/
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
