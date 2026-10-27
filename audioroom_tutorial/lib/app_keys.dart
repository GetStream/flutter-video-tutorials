import 'package:audioroom_tutorial/env_setup.dart';

/// This project is a sample app created based on the audio room tutorial.
/// It's also a great playground to test your audio room setup configured in your Stream Dashboard.
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

  // User 1 credentials
  static const String user1Id = 'alice_johnson_audioroom';
  static const String user1Name = 'Alice Johnson';
  static String get user1Token =>
      _env['STREAM_TOKEN_ALICE_JOHNSON_AUDIOROOM'] ?? '';

  // User 2 credentials
  static const String user2Id = 'bob_smith_audioroom';
  static const String user2Name = 'Bob Smith';
  static String get user2Token =>
      _env['STREAM_TOKEN_BOB_SMITH_AUDIOROOM'] ?? '';

  // User 3 credentials
  static const String user3Id = 'charlie_brown_audioroom';
  static const String user3Name = 'Charlie Brown';
  static String get user3Token =>
      _env['STREAM_TOKEN_CHARLIE_BROWN_AUDIOROOM'] ?? '';

  /// The names of the `env/env.json` entries that are missing or empty.
  static List<String> get missingEnvKeys => [
    for (final key in const [
      'STREAM_API_KEY',
      'STREAM_TOKEN_ALICE_JOHNSON_AUDIOROOM',
      'STREAM_TOKEN_BOB_SMITH_AUDIOROOM',
      'STREAM_TOKEN_CHARLIE_BROWN_AUDIOROOM',
    ])
      if ((_env[key] ?? '').isEmpty) key,
  ];
}
