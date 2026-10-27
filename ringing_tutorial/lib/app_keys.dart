import 'package:ringing_tutorial/env_setup.dart';

/// This project is a sample app created based on the ringing tutorial (https://getstream.io/video/sdk/flutter/tutorial/ringing/).
/// It's also a great playground to test your ringing setup configured in your Stream Dashboard,
/// as it should work seamlessly with this app once properly configured.
///
/// Besides the Stream credentials below, push notifications need your own
/// Firebase project and push providers in the Stream Dashboard. See the
/// README.md file in this project for the full setup.
///
/// The API key and the user tokens are not part of the source code. They are
/// read from `env/env.json` when the app starts, see [AppKeys.load].
///
/// Create `env/env.json` by running `scripts/generate_env.sh` from the
/// repository root, or copy `env/env.example.json` and fill it in by hand. See
/// the README for details.
class AppKeys {
  AppKeys._();

  static Map<String, String> _env = const {};

  /// Reads the values from `env/env.json`. Call before using the keys.
  static Future<void> load() async => _env = await loadEnv();

  // Your Stream API key from the Stream Dashboard
  static String get streamApiKey => _env['STREAM_API_KEY'] ?? '';

  // Push notification provider names (configure these in Stream Dashboard)
  static String get iosPushProviderName =>
      _nonEmpty(_env['STREAM_IOS_PUSH_PROVIDER']) ?? 'apn-flutter-sample';
  static String get androidPushProviderName =>
      _nonEmpty(_env['STREAM_ANDROID_PUSH_PROVIDER']) ?? 'flutter-firebase';

  // Configure at least two test users for the demo
  static const String user1Id = 'alice_johnson';
  static const String user1Name = 'Alice Johnson';
  static String get user1Token => _env['STREAM_TOKEN_ALICE_JOHNSON'] ?? '';

  static const String user2Id = 'bob_smith';
  static const String user2Name = 'Bob Smith';
  static String get user2Token => _env['STREAM_TOKEN_BOB_SMITH'] ?? '';

  static const String user3Id = 'charlie_brown';
  static const String user3Name = 'Charlie Brown';
  static String get user3Token => _env['STREAM_TOKEN_CHARLIE_BROWN'] ?? '';

  /// The names of the `env/env.json` entries that are missing or empty.
  static List<String> get missingEnvKeys => [
    for (final key in const [
      'STREAM_API_KEY',
      'STREAM_TOKEN_ALICE_JOHNSON',
      'STREAM_TOKEN_BOB_SMITH',
      'STREAM_TOKEN_CHARLIE_BROWN',
    ])
      if ((_env[key] ?? '').isEmpty) key,
  ];

  static String? _nonEmpty(String? value) =>
      value == null || value.isEmpty ? null : value;
}
