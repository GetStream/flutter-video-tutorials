import 'package:firebase_core/firebase_core.dart';
import 'package:ringing_tutorial/app_keys.dart';
import 'package:ringing_tutorial/firebase_options.dart';
import 'package:ringing_tutorial/tutorial_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

class AppInitializer {
  static const storedUserKey = 'loggedInUserId';

  static Future<TutorialUser?> getStoredUser() async {
    final storage = FlutterSecureStorage();

    final userId = await storage.read(key: storedUserKey);
    if (userId == null) {
      return null;
    }

    if (TutorialUser.users
        .where(
          (user) => user.user.id == userId,
        )
        .isEmpty) {
      clearStoredUser();
      return null;
    }

    return TutorialUser.users.firstWhere(
      (user) => user.user.id == userId,
    );
  }

  static Future<void> storeUser(TutorialUser tutorialUser) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: storedUserKey, value: tutorialUser.user.id);
  }

  static Future<void> clearStoredUser() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: storedUserKey);
  }

  static Future<StreamVideo> init(TutorialUser tutorialUser) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return StreamVideo(
      AppKeys.streamApiKey,
      user: tutorialUser.user,
      userToken: tutorialUser.token,
      options: const StreamVideoOptions(
        logPriority: Priority.verbose,
        keepConnectionsAliveWhenInBackground: true,
      ),
      pushNotificationManagerProvider:
          StreamVideoPushNotificationManager.create(
        iosPushProvider: const StreamVideoPushProvider.apn(
          name: AppKeys.iosPushProviderName,
        ),
        androidPushProvider: const StreamVideoPushProvider.firebase(
          name: AppKeys.androidPushProviderName,
        ),
        pushConfiguration: const StreamVideoPushConfiguration(
          ios: IOSPushConfiguration(iconName: 'IconMask'),
        ),
        registerApnDeviceToken: true,
      ),
    )..connect();
  }
}
