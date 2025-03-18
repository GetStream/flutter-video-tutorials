## Flutter Ringing Tutorial

📚 [Ringing Tutorial](https://getstream.io/video/sdk/flutter/tutorial/ringing/)   |||   💻 [Ringing Repository](https://github.com/GetStream/flutter-video-tutorials/tree/main/ringing_tutorial)

The Flutter Ringing tutorial provides a step-by-step guide to building an app with ringing functionality using Stream's Video API and Stream Video Flutter components.

# Project Setup Guide

## Prerequisites
- A Stream account with created App (https://dashboard.getstream.io)
- Firebase project for push notifications
- Your Stream API Key and User Tokens

## 1. Firebase Configuration

### Android Setup
1. Create a new Firebase project or use an existing one
2. Register your Android app with package name: `io.getstream.flutter.sample.ringing` or change the package name if you want to.
3. Download `google-services.json` and place it in:
   ```
   android/app/google-services.json
   ```
4. Create a Firebase provider in Stream dashboard, follow this [doc](https://getstream.io/video/docs/flutter/advanced/incoming-calls/providers-configuration/#creating-firebase-provider).

### iOS Setup
1. Change the bundle ID for the project and register it in your Apple Developer account.
2. Create an APN provider in Stream dashboard, follow this [doc](https://getstream.io/video/docs/flutter/advanced/incoming-calls/providers-configuration/#creating-apns-provider).

## 2. Stream Configuration
Update `lib/app_keys.dart` with your Stream credentials:

```dart
class AppKeys {
  // Your Stream API key from the Stream Dashboard
  static const String streamApiKey = 'YOUR_STREAM_API_KEY';
  
  // Push notification provider names (configure these in Stream Dashboard)
  static const String iosPushProviderName = 'YOUR_APN_PROVIDER_NAME';
  static const String androidPushProviderName = 'YOUR_FIREBASE_PROVIDER_NAME';

  // Configure at least two test users for the demo
  // User 1
  static const String user1Id = 'YOUR_USER_1_ID';
  static const String user1Name = 'YOUR_USER_1_NAME';
  static const String user1Token = 'YOUR_USER_1_TOKEN'; 

  // User 2
  static const String user2Id = 'YOUR_USER_2_ID';
  static const String user2Name = 'YOUR_USER_2_NAME';
  static const String user2Token = 'YOUR_USER_2_TOKEN';

  // User 3 (optional)
  static const String user3Id = 'YOUR_USER_3_ID';
  static const String user3Name = 'YOUR_USER_3_NAME';
  static const String user3Token = 'YOUR_USER_3_TOKEN';
}
```

### How to Generate User Tokens
For testing purposes user tokens can be generated once and harcoded in the app.
For this purpose we have [this simple form](https://getstream.io/chat/docs/flutter-dart/tokens_and_authentication/#manually-generating-tokens) where you can generate a token providing Stream app secret and user Id.

## 3. Firebase Options
The `lib/firebase_options.dart` file will be automatically generated when you run:
```bash
flutterfire configure
```

Make sure you've installed the FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

## Troubleshooting

### Common Issues

#### 1. Connection Issues
- **Symptoms**: Unable to establish web socket connection, call setup fails
- **Solutions**:
  - Verify your Stream API key is correct
  - Ensure tokens are valid and generated for the correct user

#### 2. Token Issues
- **Symptoms**: Authentication failures, sudden disconnections
- **Solutions**:
  - Check token expiration date (use [jwt.io](https://jwt.io) to verify)
  - Ensure you're using your app's secret to generate tokens, not demo tokens

#### 3. Ringing Functionality Issues
- **Symptoms**: Call notifications not working, ringing not functioning
- **Solutions**:
  - Ensure you're using unique call IDs for each new call (e.g., using UUID)
  - Verify you're not trying to call yourself (same user on different devices)
  - Confirm that call recipients have connected to Stream at least once
  - Check that members exist on Stream's platform
  - Check provider names match in Stream Dashboard
  - Ensure all certificates and keys are valid

#### 4. iOS CallKit Integration Issues
- **Symptoms**: Call notifications not showing, CallKit not working
- **Solutions**:
  - Verify Do Not Disturb and Focus modes are disabled
  - Check VoIP certificate matches your bundle ID
  - Verify bundle ID matches Stream Dashboard configuration
  - Confirm push provider names are correct in SDK initialization
  - Check "Webhook & Push Logs" in Stream Dashboard

### Enabling Detailed Logging
To get more detailed logs for debugging, configure the SDK with verbose logging:

```dart
StreamVideo(
  apiKey: 'your_api_key',
  user: user,
  options: const StreamVideoOptions(
    logPriority: Priority.verbose,
  ),
);
```