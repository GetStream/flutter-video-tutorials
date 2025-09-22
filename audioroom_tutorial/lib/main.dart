// ignore: dangling_library_doc_comments
/// Sample app for the Stream Audio Room tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and usage. To run it locally, replace the placeholder
/// credentials in `main()` with your own:
/// - API key
/// - User ID
/// - User token
///
/// You can obtain demo credentials from the tutorial page:
/// https://getstream.io/video/sdk/flutter/tutorial/audio-room/
///
/// After updating the values below, run the app on a device or emulator.
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'home_screen.dart';

Future<void> main() async {
  // Ensure Flutter is able to communicate with Plugins
  WidgetsFlutterBinding.ensureInitialized();

  // Replace the placeholders below with your API key, user ID, and user token.
  // Get demo credentials at: https://getstream.io/video/sdk/flutter/tutorial/audio-room/
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

  runApp(
    const MaterialApp(
      home: HomeScreen(),
    ),
  );
}
