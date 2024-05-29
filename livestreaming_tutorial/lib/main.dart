import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'home_screen.dart';

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stream video and set the API key for our app.
  StreamVideo(
    'REPLACE_WITH_API_KEY',
    user: const User(
      info: UserInfo(
        name: 'John Doe',
        id: 'REPLACE_WITH_USER_ID',
      ),
    ),
    userToken: 'REPLACE_WITH_TOKEN',
  );

  // For connecting anonymous users
  // StreamVideo(
  //   'REPLACE_WITH_API_KEY',
  //   user: User.anonymous(),
  //   userToken: 'REPLACE_WITH_TOKEN',
  // );

  runApp(
    const MaterialApp(
      home: HomeScreen(),
    ),
  );
}
