// ignore: dangling_library_doc_comments
/// Sample app for the Stream Video Calling tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and usage. To run it locally, replace the placeholders in
/// `main()` with your own credentials:
/// - API key
/// - User ID and token
/// - Call ID (when creating a call)
///
/// You can obtain demo credentials from the tutorial page:
/// https://getstream.io/video/sdk/flutter/tutorial/video-calling/
///
/// After updating the values below, run the app on a device or emulator.
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:video_calling_tutorial/call_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Right after creation client connects to the backend and authenticates the user.
  // You can set `options: StreamVideoOptions(autoConnect: false)` if you want to disable auto-connect.
  StreamVideo(
    'REPLACE_WITH_API_KEY',
    user: User.regular(
      userId: 'REPLACE_WITH_USER_ID',
      role: 'admin',
      name: 'John Doe',
    ),
    userToken: 'REPLACE_WITH_TOKEN',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Create Call'),
          onPressed: () async {
            try {
              var call = StreamVideo.instance.makeCall(
                callType: StreamCallType.defaultType(),
                id: 'REPLACE_WITH_CALL_ID',
              );

              await call.getOrCreate();

              if (!context.mounted) return;

              // Created ahead
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CallScreen(call: call),
                ),
              );
            } catch (e) {
              debugPrint('Error joining or creating call: $e');
              debugPrint(e.toString());
            }
          },
        ),
      ),
    );
  }
}
