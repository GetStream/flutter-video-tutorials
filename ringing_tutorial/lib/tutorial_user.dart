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
          userId: '{REPLACE_WITH_USER_1_ID}',
          name: '{REPLACE_WITH_USER_1_NAME}',
          image:
              'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
        token: '{REPLACE_WITH_USER_1_TOKEN}',
      );

  factory TutorialUser.user2() => TutorialUser(
        user: User.regular(
          userId: '{REPLACE_WITH_USER_2_ID}',
          name: '{REPLACE_WITH_USER_2_NAME}',
          image:
              'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
        token: '{REPLACE_WITH_USER_2_TOKEN}',
      );

  factory TutorialUser.user3() => TutorialUser(
        user: User.regular(
          userId: '{REPLACE_WITH_USER_3_ID}',
          name: '{REPLACE_WITH_USER_2_NAME}',
          image:
              'https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=600',
        ),
        token: '{REPLACE_WITH_USER_3_TOKEN}',
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
