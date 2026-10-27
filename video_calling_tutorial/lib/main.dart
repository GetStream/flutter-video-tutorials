// ignore: dangling_library_doc_comments
/// Sample app for the Stream Video Calling tutorial.
///
/// This project is a minimal example used in the tutorial to demonstrate
/// basic setup and usage. It reads your Stream API key and user tokens from
/// `env/env.json`, see the README for how to create it.
///
/// After creating `env/env.json`, run the app on a device or emulator.
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:video_calling_tutorial/app_keys.dart';
import 'package:video_calling_tutorial/call_screen.dart';
import 'package:video_calling_tutorial/env_setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppKeys.load();
  final missingEnvKeys = AppKeys.missingEnvKeys;
  if (missingEnvKeys.isNotEmpty) {
    runApp(MissingEnvApp(missingKeys: missingEnvKeys));
    return;
  }

  /// The API key and the user token are read from `env/env.json`, see the
  /// README. For production apps, generate tokens on your server rather than
  /// in the client.
  StreamVideo(
    AppKeys.streamApiKey,
    user: User.regular(
      userId: AppKeys.user1Id,
      role: 'admin',
      name: AppKeys.user1Name,
    ),
    userToken: AppKeys.user1Token,
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
