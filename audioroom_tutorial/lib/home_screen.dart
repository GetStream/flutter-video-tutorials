import 'dart:math';

import 'package:audioroom_tutorial/audio_room_screen.dart';
import 'package:audioroom_tutorial/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? createLoadingText;
  String? joinLoadingText;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Room Tutorial'),
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
                        () => createLoadingText = 'Creating Audio Room...',
                      );
                      await _createAudioRoom();
                      setState(() => createLoadingText = null);
                    }
                  : null,
              child: Text(createLoadingText ?? 'Create an Audio Room'),
            ),
            ElevatedButton(
              onPressed: joinLoadingText == null
                  ? () async {
                      await _joinAudioRoom();
                    }
                  : null,
              child: Text(joinLoadingText ?? 'Join an Audio Room'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createAudioRoom() async {
    // Generate a random short call ID
    final callId = _generateRandomCallId();

    // Set up our call object
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.audioRoom(),
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

    final connectOptions = CallConnectOptions(
      microphone: TrackOption.enabled(),
    );

    await call.join(connectOptions: connectOptions);

    // Allow others to see and join the call (exit backstage mode)
    await call.goLive();

    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AudioRoomScreen(
            audioRoomCall: call,
          ),
        ),
      );
    }
  }

  Future<void> _joinAudioRoom() async {
    // Show dialog to get call ID from user
    final callId = await _showCallIdDialog();
    if (callId == null || callId.isEmpty) {
      return;
    }

    setState(() {
      joinLoadingText = 'Joining Audio Room...';
    });

    // Set up our call object
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.audioRoom(),
      id: callId,
    );

    final result = await call.getOrCreate();

    if (result.isSuccess) {
      // Join with microphone disabled by default
      final connectOptions = CallConnectOptions(
        microphone: TrackOption.disabled(),
      );

      final joinResult = await call.join(connectOptions: connectOptions);
      setState(() => joinLoadingText = null);

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

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AudioRoomScreen(
            audioRoomCall: call,
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
      setState(() => joinLoadingText = null);
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
            hintText: 'Enter the audio room call ID',
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
