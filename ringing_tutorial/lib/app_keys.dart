/// Replace the values below with your own Stream API keys and sample user data if you want to test your Stream app.
/// For development, you can generate user tokens with our online tool: https://getstream.io/chat/docs/flutter-dart/tokens_and_authentication/#manually-generating-tokens
/// For production apps, generate tokens on your server rather than in the client.
class AppKeys {
  // Your Stream API key from the Stream Dashboard
  static const String streamApiKey = 'mmhfdzb5evj2';

  // Push notification provider names (configure these in Stream Dashboard)
  static const String iosPushProviderName = 'apn-flutter-sample';
  static const String androidPushProviderName = 'flutter-firebase';

  // Configure at least two test users for the demo
  static const String user1Id = 'alice_johnson';
  static const String user1Name = 'Alice Johnson';
  static const String user1Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYWxpY2Vfam9obnNvbiJ9.v6-yXWgbLyykj9yt_ophmaC5FCGAG9ic6p02V09CmKQ';

  static const String user2Id = 'bob_smith';
  static const String user2Name = 'Bob Smith';
  static const String user2Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiYm9iX3NtaXRoIn0.rYCa73497wMkuiNC9P8xoEiiXlMxX_CJwBzU33-ZbHY';

  static const String user3Id = 'charlie_brown';
  static const String user3Name = 'Charlie Brown';
  static const String user3Token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiY2hhcmxpZV9icm93biJ9.Xb9gFT9TqlTCvKgB2PgN9ugSWIGguscHIxG_dQIhVWY';
}
