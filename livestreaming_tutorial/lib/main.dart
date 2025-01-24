import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'home_screen.dart';

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Stream video and set the API key for our app.
  StreamVideo(
    'mmhfdzb5evj2',
    user: const User(
      info: UserInfo(
        name: 'John Doe',
        id: 'demo',
        role: 'admin'
      ),
    ),
    userToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL1RhbG9uX0thcnJkZSIsInVzZXJfaWQiOiJUYWxvbl9LYXJyZGUiLCJ2YWxpZGl0eV9pbl9zZWNvbmRzIjo2MDQ4MDAsImlhdCI6MTczNzcxNDU0MiwiZXhwIjoxNzM4MzE5MzQyfQ.mroo_g3_UNMWokded07DCx34d8VX6pBhyuEpzD1ZBGE',
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
