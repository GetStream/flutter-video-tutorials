import 'package:audioroom_tutorial/audio_room_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _createAudioRoom(),
          child: const Text('Create an Audio Room'),
        ),
      ),
    );
  }

  Future<void> _createAudioRoom() async {
    // Set up our call object
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.audioRoom(),
      id: 'REPLACE_WITH_CALL_ID',
    );

    final result = await call.getOrCreate(); // Call object is created

    if (result.isSuccess) {
      await call.join(); // Our local app user can join and receive events
      await call.goLive(); // Allow others to see and join the call

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AudioRoomScreen(
            audioRoomCall: call,
          ),
        ),
      );
    } else {
      debugPrint('Not able to create a call.');
    }
  }
}