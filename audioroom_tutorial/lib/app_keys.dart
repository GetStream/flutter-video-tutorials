/// This project is a sample app created based on the audio room tutorial.
/// It's also a great playground to test your audio room setup configured in your Stream Dashboard.
///
/// CONFIGURATION REQUIRED TO USE YOUR OWN STREAM CREDENTIALS
///
/// To use this project with your Stream App credentials, you need to complete the following steps:
///
/// 1. CONFIGURE STREAM DASHBOARD AND REPLACE APP KEYS:
///    - Replace the `streamApiKey` below with your Stream API key from the Stream Dashboard
///    - Generate new user tokens for your test users using the Stream token generator: https://getstream.io/chat/docs/flutter-dart/tokens_and_authentication/#manually-generating-tokens
class AppKeys {
  // Your Stream API key from the Stream Dashboard
  static const String streamApiKey = 'mmhfdzb5evj2';

  // User 1 credentials
  static const String user1Id = 'alice_johnson_audioroom';
  static const String user1Name = 'Alice Johnson';
  static const String user1Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWxpY2Vfam9obnNvbl9hdWRpb3Jvb20ifQ.h-ESBFCHUqM5HtCDN2BJCsowBS_cSqb-fMa5WV-t3DY';

  // User 2 credentials
  static const String user2Id = 'bob_smith_audioroom';
  static const String user2Name = 'Bob Smith';
  static const String user2Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYm9iX3NtaXRoX2F1ZGlvcm9vbSJ9.k4tUhE42ki1cntOnzJ8gNkJOgiJLVdPIJDV-G_Z3WoI';

  // User 3 credentials
  static const String user3Id = 'charlie_brown_audioroom';
  static const String user3Name = 'Charlie Brown';
  static const String user3Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiY2hhcmxpZV9icm93bl9hdWRpb3Jvb20ifQ.h79veCz7VMRf-HDy3EBk4wvbBJSnu9rk-PszaGEc3MU';
}
