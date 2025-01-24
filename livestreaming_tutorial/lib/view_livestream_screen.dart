import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class ViewLivestreamScreen extends StatefulWidget {
  const ViewLivestreamScreen({super.key});

  @override
  State<ViewLivestreamScreen> createState() => _ViewLivestreamScreenState();
}

class _ViewLivestreamScreenState extends State<ViewLivestreamScreen> {
  // TODO: REPLACE CREDENTIALS
  final callId = "REPLACE_WITH_CALL_ID";

  Call? _livestreamCall;

  @override
  void initState() {
    super.initState();
    _initCall();
  }

  void _initCall() async {
    var call = StreamVideo.instance.makeCall(
      id: callId,
      callType: StreamCallType.liveStream(),
    );
    await call.getOrCreate();
    await call.join();
    setState(() {
      _livestreamCall = call;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_livestreamCall == null) {
      return const Material(
        child: Center(
          child: Text('Initialising...'),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: LivestreamPlayer(
          call: _livestreamCall!,
        ),
      ),
    );
  }
}
