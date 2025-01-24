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
    userToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL0dpbGFkX1BlbGxhZW9uIiwidXNlcl9pZCI6IkdpbGFkX1BlbGxhZW9uIiwidmFsaWRpdHlfaW5fc2Vjb25kcyI6NjA0ODAwLCJpYXQiOjE3Mzc3MTQ5NzcsImV4cCI6MTczODMxOTc3N30.h-lqD7KPZCq7G6izI-73XO9nOC5ZahpGIHbzWfFmKOw',
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
