import 'package:firebase_core/firebase_core.dart';
import 'package:ringing_tutorial/firebase_options.dart';
import 'package:ringing_tutorial/tutorial_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:stream_video_push_notification/stream_video_push_notification.dart';

class AppInitializer {
  static const storedUserKey = 'loggedInUserId';

  static Future<TutorialUser?> getStoredUser() async {
    return SharedPreferences.getInstance().then((prefs) {
      final userId = prefs.getString(storedUserKey);
      if (userId == null) {
        return null;
      }

      return TutorialUser.users.firstWhere(
        (user) => user.user.id == userId,
      );
    });
  }

  static Future<void> storeUser(TutorialUser tutorialUser) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(storedUserKey, tutorialUser.user.id);
    });
  }

  static Future<void> clearStoredUser() async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove(storedUserKey);
    });
  }

  static Future<StreamVideo> init(TutorialUser tutorialUser) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return StreamVideo(
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
  }
}
