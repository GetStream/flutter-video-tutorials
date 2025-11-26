import 'package:audioroom_tutorial/app_keys.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class TutorialUser {
  const TutorialUser({
    required this.user,
    required this.token,
  });

  final User user;
  final String? token;

  factory TutorialUser.user1() => TutorialUser(
        user: User.regular(
          userId: AppKeys.user1Id,
          name: AppKeys.user1Name,
          image: 'https://robohash.org/${AppKeys.user1Id}',
        ),
        token: AppKeys.user1Token,
      );

  factory TutorialUser.user2() => TutorialUser(
        user: User.regular(
          userId: AppKeys.user2Id,
          name: AppKeys.user2Name,
          image: 'https://robohash.org/${AppKeys.user2Id}',
        ),
        token: AppKeys.user2Token,
      );

  factory TutorialUser.user3() => TutorialUser(
        user: User.regular(
          userId: AppKeys.user3Id,
          name: AppKeys.user3Name,
          image: 'https://robohash.org/${AppKeys.user3Id}',
        ),
        token: AppKeys.user3Token,
      );

  static List<TutorialUser> get users => [
        TutorialUser.user1(),
        TutorialUser.user2(),
        TutorialUser.user3(),
      ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TutorialUser && other.user.id == user.id;
  }

  @override
  int get hashCode => user.id.hashCode;
}
