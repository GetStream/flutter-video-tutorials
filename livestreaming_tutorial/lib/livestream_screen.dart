import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({
    super.key,
    required this.livestreamCall,
    required this.callId,
  });

  final Call livestreamCall;
  final String callId;

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
    return PartialCallStateBuilder(
      call: widget.livestreamCall,
      selector: (state) =>
          (isBackstage: state.isBackstage, endedAt: state.endedAt),
      builder: (context, callState) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              if (callState.isBackstage) {
                return BackstageWidget(
                  call: widget.livestreamCall,
                  callId: widget.callId,
                );
              }

              if (callState.endedAt != null) {
                return LivestreamEndedWidget(
                  call: widget.livestreamCall,
                );
              }

              return LivestreamLiveWidget(
                call: widget.livestreamCall,
                callId: widget.callId,
              );
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
    required this.call,
    required this.callId,
  });

  final Call call;
  final String callId;

  @override
  Widget build(BuildContext context) {
    return PartialCallStateBuilder(
      call: call,
      selector: (state) =>
          state.callParticipants.where((p) => !p.roles.contains('host')).length,
      builder: (context, waitingParticipantsCount) {
        return Center(
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      'Call ID',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      callId,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                    ),
                  ],
                ),
              ),
              PartialCallStateBuilder(
                  call: call,
                  selector: (state) => state.startsAt,
                  builder: (context, startsAt) {
                    return Text(
                      startsAt != null
                          ? 'Livestream starting at ${DateFormat('HH:mm').format(startsAt.toLocal())}'
                          : 'Livestream starting soon',
                      style: Theme.of(context).textTheme.titleLarge,
                    );
                  }),
              if (waitingParticipantsCount > 0)
                Text('$waitingParticipantsCount participants waiting'),
              const SizedBox(height: 30),
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
      },
    );
  }
}

class LivestreamEndedWidget extends StatefulWidget {
  const LivestreamEndedWidget({
    super.key,
    required this.call,
  });

  final Call call;

  @override
  State<LivestreamEndedWidget> createState() => _LivestreamEndedWidgetState();
}

class _LivestreamEndedWidgetState extends State<LivestreamEndedWidget> {
  late Future<Result<List<CallRecording>>> _recordingsFuture;

  @override
  void initState() {
    super.initState();
    _recordingsFuture = widget.call.listRecordings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.call.leave();
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
              future: _recordingsFuture,
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
    required this.call,
    required this.callId,
  });

  final Call call;
  final String callId;

  @override
  Widget build(BuildContext context) {
    return StreamCallContainer(
      call: call,
      callContentWidgetBuilder: (context, call) {
        return PartialCallStateBuilder(
          call: call,
          selector: (state) => state.callParticipants
              .where((e) => e.roles.contains('host'))
              .toList(),
          builder: (context, hosts) {
            if (hosts.isEmpty) {
              return const Center(
                child: Text("The host's video is not available"),
              );
            }

            return StreamCallContent(
              call: call,
              callAppBarWidgetBuilder: (context, call) => CallAppBar(
                call: call,
                showBackButton: false,
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PartialCallStateBuilder(
                      call: call,
                      selector: (state) => state.callParticipants.length,
                      builder: (context, count) => Text(
                        'Viewers: $count',
                      ),
                    ),
                    Text(
                      'Call ID: $callId',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                onLeaveCallTap: () {
                  call.stopLive();
                },
              ),
              callParticipantsWidgetBuilder: (context, call) {
                return StreamCallParticipants(
                  call: call,
                  participants: hosts,
                );
              },
            );
          },
        );
      },
    );
  }
}
