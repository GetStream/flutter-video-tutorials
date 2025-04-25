import 'package:flutter/material.dart';
import 'package:livestreaming_tutorial/livestream_screen.dart';
import 'package:stream_video/stream_video.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            ElevatedButton(
              onPressed: () => _createLivestream(),
              child: const Text('Create a Livestream'),
            ),
            ElevatedButton(
              onPressed: () => _viewLivestream(),
              child: const Text('View a Livestream'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createLivestream() async {
    // Set up our call object
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.liveStream(),
      id: 'REPLACE_WITH_CALL_ID',
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

    // Configure the call to allow users to join before it starts by setting a future start time
    // and specifying how many seconds in advance they can join via `joinAheadTimeSeconds`
    if (result.isSuccess) {
      final updateResult = await call.update(
        startsAt: DateTime.now().toUtc().add(const Duration(seconds: 120)),
        backstage: const StreamBackstageSettings(
          enabled: true,
          joinAheadTimeSeconds: 120,
        ),
      );
    }

    if (result.isSuccess) {
      // Set some default behaviour for how our devices should be configured once we join a call
      final connectOptions = CallConnectOptions(
        camera: TrackOption.enabled(),
        microphone: TrackOption.enabled(),
      );

      // Our local app user can join and receive events
      await call.join(connectOptions: connectOptions);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LiveStreamScreen(livestreamCall: call),
        ),
      );
    } else {
      debugPrint('Not able to create a call.');
    }
  }

  Future<void> _viewLivestream() async {
    // Set up our call object
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.liveStream(),
      id: 'REPLACE_WITH_CALL_ID',
    );

    final result = await call.getOrCreate(); // Call object is created

    if (result.isSuccess) {
      // Set default behaviour for a livestream viewer
      final connectOptions = CallConnectOptions(
        camera: TrackOption.disabled(),
        microphone: TrackOption.disabled(),
      );

      // Our local app user can join and receive events
      await call.join(connectOptions: connectOptions);

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
    }
  }
}
