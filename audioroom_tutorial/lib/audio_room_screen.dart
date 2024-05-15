import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class AudioRoomScreen extends StatefulWidget {
  const AudioRoomScreen({
    super.key,
    required this.audioRoomCall,
  });

  final Call audioRoomCall;

  @override
  State<AudioRoomScreen> createState() => _AudioRoomScreenState();
}

class _AudioRoomScreenState extends State<AudioRoomScreen> {
  late CallState _callState;
  var microphoneEnabled = false;

  @override
  void initState() {
    super.initState();
    _callState = widget.audioRoomCall.state.value;
    widget.audioRoomCall.onPermissionRequest = (permissionRequest) {
      widget.audioRoomCall.grantPermissions(
        userId: permissionRequest.user.id,
        permissions: permissionRequest.permissions.toList(),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Room: ${_callState.callId}'),
        leading: IconButton(
          onPressed: () async {
            await widget.audioRoomCall.leave();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.close,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: microphoneEnabled
            ? const Icon(Icons.mic)
            : const Icon(Icons.mic_off),
        onPressed: () {
          if (microphoneEnabled) {
            widget.audioRoomCall.setMicrophoneEnabled(enabled: false);
            setState(() {
              microphoneEnabled = false;
            });
          } else {
            if (!widget.audioRoomCall.hasPermission(CallPermission.sendAudio)) {
              widget.audioRoomCall.requestPermissions(
                [CallPermission.sendAudio],
              );
            }
            widget.audioRoomCall.setMicrophoneEnabled(enabled: true);
            setState(() {
              microphoneEnabled = true;
            });
          }
        },
      ),
      body: StreamBuilder<CallState>(
        initialData: _callState,
        stream: widget.audioRoomCall.state.valueStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Cannot fetch call state.'),
            );
          }
          if (snapshot.hasData && !snapshot.hasError) {
            var callState = snapshot.data!;

            return GridView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Align(
                  widthFactor: 0.8,
                  child: StreamCallParticipant(
                    call: widget.audioRoomCall,
                    backgroundColor: Colors.transparent,
                    participant: callState.callParticipants[index],
                    showParticipantLabel: true,
                    showConnectionQualityIndicator: false,
                    userAvatarTheme: const StreamUserAvatarThemeData(
                      constraints: BoxConstraints.expand(
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: callState.callParticipants.length,
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
