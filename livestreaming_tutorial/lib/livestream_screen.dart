import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({
    super.key,
  });

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
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

    return StreamBuilder(
      stream: _livestreamCall!.state.valueStream,
      initialData: _livestreamCall!.state.value,
      builder: (context, snapshot) {
        final callState = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: OutlinedButton(
                  onPressed: () {
                    _livestreamCall!.end();
                    Navigator.pop(context);
                  },
                  child: const Text('End Call'),
                ),
              ),
            ],
            title: Text('Viewers: ${callState.callParticipants.length}'),
            automaticallyImplyLeading: false,
          ),
          body: Builder(
            builder: (context) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData && callState.isBackstage) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Stream not live'),
                        ElevatedButton(
                          onPressed: () {
                            _livestreamCall!.goLive();
                          },
                          child: const Text('Go Live'),
                        ),
                      ],
                    ),
                  );
                }

                return StreamCallContainer(
                  call: _livestreamCall!,
                  callContentBuilder: (context, call, state) {
                    var participant = state.callParticipants.firstWhere(
                        (e) => e.userId == StreamVideo.instance.currentUser.id);

                    return StreamCallContent(
                      call: call,
                      callState: callState,
                      callParticipantsBuilder: (context, call, state) {
                        return StreamCallParticipants(
                          call: call,
                          participants: [participant],
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
