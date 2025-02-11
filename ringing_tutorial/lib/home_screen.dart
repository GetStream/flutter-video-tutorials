import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ringing_tutorial/app_initializer.dart';
import 'package:ringing_tutorial/call_screen.dart';
import 'package:ringing_tutorial/firebase_options.dart';
import 'package:ringing_tutorial/login_screen.dart';
import 'package:ringing_tutorial/tutorial_user.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';
import 'package:uuid/uuid.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialise Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    final tutorialUser = await AppInitializer.getStoredUser();
    if (tutorialUser == null) return;

    final streamVideo = StreamVideo.create(
      '{REPLACE_WITH_YOUR_STREAM_API_KEY}',
      user: tutorialUser.user,
      userToken: tutorialUser.token,
      options: const StreamVideoOptions(
        logPriority: Priority.verbose,
        keepConnectionsAliveWhenInBackground: true,
      ),
      pushNotificationManagerProvider:
          StreamVideoPushNotificationManager.create(
        iosPushProvider: const StreamVideoPushProvider.apn(
          name: '{REPLACE_WITH_YOUR_APN_PROVIDER_NAME}',
        ),
        androidPushProvider: const StreamVideoPushProvider.firebase(
          name: '{REPLACE_WITH_YOUR_FIREBASE_PROVIDER_NAME}',
        ),
        pushParams: const StreamVideoPushParams(
          appName: 'Ringing Tutorial',
          ios: IOSParams(iconName: 'IconMask'),
        ),
        registerApnDeviceToken: true,
      ),
    )..connect();

    final subscription = streamVideo.observeCallDeclinedCallKitEvent();
    streamVideo.disposeAfterResolvingRinging(
      disposingCallback: () => subscription?.cancel(),
    );

    await streamVideo.handleRingingFlowNotifications(message.data);
  } catch (e, stk) {
    debugPrint('Error handling remote message: $e');
    debugPrint(stk.toString());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _fcmSubscription = 1;
  static const int _callKitSubscription = 2;

  final Subscriptions subscriptions = Subscriptions();
  final List<String> selectedUserIds = [];
  bool videoCall = true;

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.requestPermission();

    _tryConsumingIncomingCallFromTerminatedState();

    _observeFcmMessages();
    _observeCallKitEvents();
  }

  void _tryConsumingIncomingCallFromTerminatedState() {
    // This is only relevant for Android.
    if (CurrentPlatform.isIos) return;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _consumeIncomingCall();
    });
  }

  Future<void> _consumeIncomingCall() async {
    final calls =
        await StreamVideo.instance.pushNotificationManager?.activeCalls();
    if (calls == null || calls.isEmpty) return;

    final callResult = await StreamVideo.instance.consumeIncomingCall(
      uuid: calls.first.uuid!,
      cid: calls.first.callCid!,
    );

    callResult.fold(success: (result) async {
      final call = result.data;
      await call.accept();

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(call: call),
          ),
        );
      }
    }, failure: (error) {
      debugPrint('Error consuming incoming call: $error');
    });
  }

  Future<bool> _handleRemoteMessage(RemoteMessage message) async {
    return StreamVideo.instance.handleRingingFlowNotifications(message.data);
  }

  _observeFcmMessages() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    subscriptions.add(
      _fcmSubscription,
      FirebaseMessaging.onMessage.listen(_handleRemoteMessage),
    );
  }

  void _observeCallKitEvents() {
    final streamVideo = StreamVideo.instance;

    subscriptions.add(
      _callKitSubscription,
      streamVideo.observeCoreCallKitEvents(
        onCallAccepted: (callToJoin) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallScreen(
                call: callToJoin,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _createRingingCall() async {
    final call = StreamVideo.instance.makeCall(
      callType: StreamCallType.defaultType(),
      id: Uuid().v4(),
    );

    final result = await call.getOrCreate(
      memberIds: selectedUserIds,
      video: videoCall,
      ringing: true,
    );

    result.fold(
      success: (success) async {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CallScreen(
                call: call,
              ),
            ),
          );
        }
      },
      failure: (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.error.message),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringing Tutorial'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await StreamVideo.instance.disconnect();
              await StreamVideo.reset();
              await AppInitializer.clearStoredUser();

              subscriptions.cancelAll();

              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
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
          children: [
            Text(
              'Hello ${StreamVideo.instance.currentUser.name}!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 90),
            Text(
              'Select who would you like to ring?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...TutorialUser.users
                    .where(
                        (u) => u.user.id != StreamVideo.instance.currentUser.id)
                    .map((user) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (selectedUserIds.contains(user.user.id)) {
                        selectedUserIds.remove(user.user.id);
                      } else {
                        selectedUserIds.add(user.user.id);
                      }

                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: selectedUserIds.contains(user.user.id)
                          ? Colors.green
                          : null,
                    ),
                    child: Text(user.user.name ?? ''),
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Should it be a video or audio call?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      videoCall = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: videoCall ? Colors.green : null,
                  ),
                  child: Text('Video'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      videoCall = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: !videoCall ? Colors.green : null,
                  ),
                  child: Text('Audio'),
                ),
              ],
            ),
            const SizedBox(height: 90),
            ElevatedButton(
              onPressed: selectedUserIds.isEmpty ? null : _createRingingCall,
              child: const Text('RING'),
            ),
            const SizedBox(height: 90),
            ElevatedButton(
              onPressed: () async {
                final devices = await StreamVideo.instance.getDevices();
                devices.fold(
                    success: (success) async {
                      for (final device in success.data) {
                        await StreamVideo.instance
                            .removeDevice(pushToken: device.pushToken);
                      }
                    },
                    failure: (_) {});
              },
              child: const Text('CLEAR DEVICES'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscriptions.cancelAll();
    super.dispose();
  }
}
