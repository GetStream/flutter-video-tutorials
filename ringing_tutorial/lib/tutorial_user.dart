import 'package:ringing_tutorial/env_consts.dart';
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
          userId: EnvConsts.user1Id,
          name: EnvConsts.user1Name,
          image:
              'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
        token: EnvConsts.user1Token,
      );

  factory TutorialUser.user2() => TutorialUser(
        user: User.regular(
          userId: EnvConsts.user2Id,
          name: EnvConsts.user2Name,
          image:
              'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
        token: EnvConsts.user2Token,
      );

  factory TutorialUser.user3() => TutorialUser(
        user: User.regular(
          userId: EnvConsts.user3Id,
          name: EnvConsts.user3Name,
          image:
              'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
        token: EnvConsts.user3Token,
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
