import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key, required this.livestreamCall});

  final Call livestreamCall;

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  late StreamSubscription<CallState> _callStateSubscription;

  @override
  void initState() {
    super.initState();

    _callStateSubscription = widget.livestreamCall.state.valueStream
        .distinct((previous, current) => previous.status != current.status)
        .listen((event) {
      if (event.status is CallStatusDisconnected) {
        // Prompt the user to check their internet connection
      }
    });
  }

  @override
  void dispose() {
    _callStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // We use distinct to prevent unnecessary rebuilds of the UI
      stream: widget.livestreamCall.state.valueStream.distinct(
        (previous, current) =>
            previous.isBackstage == current.isBackstage &&
            previous.endedAt == current.endedAt,
      ),
      initialData: widget.livestreamCall.state.value,
      builder: (context, snapshot) {
        final callState = snapshot.data!;

        return Scaffold(
          body: Builder(
            builder: (context) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (callState.isBackstage) {
                  return BackstageWidget(
                    callState: callState,
                    call: widget.livestreamCall,
                  );
                }

                if (callState.endedAt != null) {
                  return LivestreamEndedWidget(
                    callState: callState,
                    call: widget.livestreamCall,
                  );
                }

                return LivestreamLiveWidget(
                  callState: callState,
                  call: widget.livestreamCall,
                );
              }
            },
          ),
        );
      },
    );
  }
}

class BackstageWidget extends StatelessWidget {
  const BackstageWidget({
    super.key,
    required this.callState,
    required this.call,
  });

  final CallState callState;
  final Call call;

  @override
  Widget build(BuildContext context) {
    final startsAt = callState.startsAt;
    final waitingParticipants = callState.callParticipants
        .where((p) => !p.roles.contains('host'))
        .toList();

    return Center(
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            startsAt != null
                ? 'Livestream starting at ${DateFormat('HH:mm').format(startsAt.toLocal())}'
                : 'Livestream starting soon',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if (waitingParticipants.isNotEmpty)
            Text('${waitingParticipants.length} participants waiting'),
          ElevatedButton(
            onPressed: () {
              call.goLive();
            },
            child: const Text('Go Live'),
          ),
          ElevatedButton(
            onPressed: () {
              call.leave();
              Navigator.pop(context);
            },
            child: const Text('Leave Livestream'),
          ),
        ],
      ),
    );
  }
}

class LivestreamEndedWidget extends StatelessWidget {
  const LivestreamEndedWidget({
    super.key,
    required this.callState,
    required this.call,
  });

  final CallState callState;
  final Call call;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            call.leave();
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Livestream has ended'),
            FutureBuilder(
              future: call.listRecordings(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isSuccess) {
                  final recordings = snapshot.requireData.getDataOrNull();

                  if (recordings == null || recordings.isEmpty) {
                    return const Text('No recordings found');
                  }

                  return Column(
                    children: [
                      const Text('Watch recordings'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: recordings.length,
                        itemBuilder: (context, index) {
                          final recording = recordings[index];
                          return ListTile(
                            title: Text(recording.url),
                            onTap: () {
                              // open
                            },
                          );
                        },
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LivestreamLiveWidget extends StatelessWidget {
  const LivestreamLiveWidget({
    super.key,
    required this.callState,
    required this.call,
  });

  final CallState callState;
  final Call call;

  @override
  Widget build(BuildContext context) {
    return StreamCallContainer(
      call: call,
      callContentBuilder: (context, call, state) {
        var participant = state.callParticipants.firstWhereOrNull(
          (e) => e.roles.contains('host'),
        );

        if (participant == null) {
          return const Center(child: Text("The host's video is not available"));
        }

        return StreamCallContent(
          call: call,
          callState: callState,
          callAppBarBuilder: (context, call, callState) => CallAppBar(
            call: call,
            showBackButton: false,
            title: Text('Viewers: ${callState.callParticipants.length}'),
            onLeaveCallTap: () {
              call.stopLive();
            },
          ),
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
}
