import 'dart:math';

import 'package:flutter/material.dart';
import 'package:livestreaming_tutorial/login_screen.dart';
import 'package:livestreaming_tutorial/livestream_screen.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_webrtc_flutter/stream_webrtc_flutter.dart' as rtc;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  String? createLoadingText;
  String? viewLoadingText;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  String _generateRandomCallId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        6,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      rtc.Helper.setAppleAudioIOMode(rtc.AppleAudioIOMode.none);
      // rtc.Helper.setAndroidAudioConfiguration(
      //     rtc.AndroidAudioConfiguration.media);
    } else if (state == AppLifecycleState.resumed) {
      rtc.Helper.setAppleAudioIOMode(rtc.AppleAudioIOMode.localAndRemote);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livestreaming Tutorial'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await StreamVideo.instance.disconnect();
              await StreamVideo.reset();

              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            Text(
              'Hello ${StreamVideo.instance.currentUser.name}!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 90),
            ElevatedButton(
              onPressed: createLoadingText == null
                  ? () async {
                      setState(
                        () => createLoadingText = 'Creating Livestream...',
                      );
                      await _createLivestream();
                      setState(() => createLoadingText = null);
                    }
                  : null,
              child: Text(createLoadingText ?? 'Create a Livestream'),
            ),
            ElevatedButton(
              onPressed: viewLoadingText == null
                  ? () async {
                      await _viewLivestream();
                    }
                  : null,
              child: Text(viewLoadingText ?? 'View a Livestream'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createLivestream() async {
    // Generate a random short call ID
    final callId = _generateRandomCallId();

    // Set up our call object
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.liveStream(),
      id: callId,
    );

    // Create the call and set the current user as a host
    final result = await call.getOrCreate(
      members: [
        MemberRequest(
          userId: StreamVideo.instance.currentUser.id,
          role: 'host',
        ),
      ],
    );

    if (result.isFailure) {
      debugPrint('Not able to create a call: ${result.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.toString()),
          ),
        );
      }
      return;
    }

    // Configure the call to allow users to join before it starts by setting a future start time
    // and specifying how many seconds in advance they can join via `joinAheadTimeSeconds`
    final updateResult = await call.update(
      startsAt: DateTime.now().toUtc().add(const Duration(seconds: 120)),
      backstage: const StreamBackstageSettings(
        enabled: true,
        joinAheadTimeSeconds: 120,
      ),
    );

    if (updateResult.isFailure) {
      debugPrint('Not able to update the call.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(updateResult.toString()),
          ),
        );
      }
      return;
    }

    // Set some default behaviour for how our devices should be configured once we join a call
    final connectOptions = CallConnectOptions(
      camera: TrackOption.enabled(),
      microphone: TrackOption.enabled(),
    );

    // Our local app user can join and receive events
    await call.join(connectOptions: connectOptions);

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LiveStreamScreen(
          livestreamCall: call,
          callId: callId,
        ),
      ),
    );
  }

  Future<void> _viewLivestream() async {
    // Show dialog to get call ID from user
    final callId = await _showCallIdDialog();
    if (callId == null || callId.isEmpty) {
      return;
    }

    setState(() {
      viewLoadingText = 'Joining Livestream...';
    });

    // Set up our call object
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.liveStream(),
      id: callId,
    );

    final result = await call.getOrCreate(); // Call object is created

    if (result.isSuccess) {
      // Set default behaviour for a livestream viewer
      final connectOptions = CallConnectOptions(
        camera: TrackOption.disabled(),
        microphone: TrackOption.disabled(),
      );

      // Our local app user can join and receive events
      final joinResult = await call.join(connectOptions: connectOptions);
      setState(() => viewLoadingText = null);

      if (joinResult case Failure failure) {
        debugPrint('Not able to join the call: ${failure.error}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Not able to join the call: ${failure.error.message}'),
            ),
          );
        }
        return;
      }

      if (!mounted) return;

      // Viewers see the simple player
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Livestream'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  call.leave();
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: LivestreamPlayer(call: call),
          ),
        ),
      );
    } else {
      debugPrint('Not able to create a call.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not able to create a call.'),
          ),
        );
      }
      setState(() => viewLoadingText = null);
    }
  }

  Future<String?> _showCallIdDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Call ID'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter the livestream call ID',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
