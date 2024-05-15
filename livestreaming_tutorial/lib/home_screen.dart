import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

import 'livestream_screen.dart';

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
        child: ElevatedButton(
          onPressed: () => _createLivestream(),
          child: const Text('Create a Livestream'),
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

    // Set some default behaviour for how our devices should be configured once we join a call
    call.connectOptions = CallConnectOptions(
      camera: TrackOption.enabled(),
      microphone: TrackOption.enabled(),
    );

    final result = await call.getOrCreate(); // Call object is created

    if (result.isSuccess) {
      await call.join(); // Our local app user can join and receive events
      await call.goLive(); // Allow others to see and join the call

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LiveStreamScreen(
            livestreamCall: call,
          ),
        ),
      );
    } else {
      debugPrint('Not able to create a call.');
    }
  }
}
