/// This project is a sample app created based on the livestreaming tutorial: https://getstream.io/video/sdk/flutter/tutorial/livestreaming/
/// It's also a great playground to test your livestreaming setup configured in your Stream Dashboard.
///
/// CONFIGURATION REQUIRED TO USE YOUR OWN STREAM CREDENTIALS
///
/// To use this project with your Stream App credentials, you need to complete the following steps:
/// For more detailed instructions, see the README.md file in this project.
///
/// 1. CONFIGURE STREAM DASHBOARD AND REPLACE APP KEYS:
///    - Replace the `streamApiKey` below with your Stream API key from the Stream Dashboard
///    - Generate new user tokens for your test users using the Stream token generator: https://getstream.io/chat/docs/flutter-dart/tokens_and_authentication/#manually-generating-tokens
class AppKeys {
  // Your Stream API key from the Stream Dashboard
  static const String streamApiKey = 'mmhfdzb5evj2';

  // User 1 credentials
  static const String user1Id = 'alice_johnson';
  static const String user1Name = 'Alice Johnson';
  static const String user1Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWxpY2Vfam9obnNvbiJ9.v6-yXWgbLyykj9yt_ophmaC5FCGAG9ic6p02V09CmKQ';

  // User 2 credentials
  static const String user2Id = 'bob_smith';
  static const String user2Name = 'Bob Smith';
  static const String user2Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYm9iX3NtaXRoIn0.rYCa73497wMkuiNC9P8xoEiiXlMxX_CJwBzU33-ZbHY';

  // User 3 credentials
  static const String user3Id = 'charlie_brown';
  static const String user3Name = 'Charlie Brown';
  static const String user3Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiY2hhcmxpZV9icm93biJ9.Xb9gFT9TqlTCvKgB2PgN9ugSWIGguscHIxG_dQIhVWY';
}
