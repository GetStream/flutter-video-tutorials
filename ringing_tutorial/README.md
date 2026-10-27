## Flutter Ringing Tutorial

📚 [Ringing Tutorial](https://getstream.io/video/sdk/flutter/tutorial/ringing/)   |||   💻 [Ringing Repository](https://github.com/GetStream/flutter-video-tutorials/tree/main/ringing_tutorial)

The Flutter Ringing tutorial provides a step-by-step guide to building an app with ringing functionality using Stream's Video API and Stream Video Flutter components.

This project is a sample app created for tutorial purposes, but it's also a great playground to test your ringing setup configured in your Stream Dashboard, as it should work seamlessly with this app once properly configured.

# Project Setup Guide

## Prerequisites
- A Stream account with created App (https://dashboard.getstream.io)
- Firebase project for push notifications
- Your Stream API key and secret, or user tokens generated for the tutorial users

## 1. Firebase Configuration

### Android Setup
1. Create a new Firebase project or use an existing one
2. Register your Android app with your desired package name
3. Download `google-services.json` and place it in:
   ```
   android/app/google-services.json
   ```
4. Update the `applicationId` in `android/app/build.gradle` to match the package name referenced in your `google-services.json`
5. Create a Firebase provider in Stream dashboard, follow this [doc](https://getstream.io/video/docs/flutter/advanced/incoming-calls/providers-configuration/#creating-firebase-provider).

### iOS Setup
1. Register your iOS app with your desired bundle identifier in your Apple Developer account
2. Download `GoogleService-Info.plist` and place it in:
   ```
   ios/Runner/GoogleService-Info.plist
   ```
3. Update the `PRODUCT_BUNDLE_IDENTIFIER` in `ios/Runner.xcodeproj/project.pbxproj` to match the bundle ID referenced in your `GoogleService-Info.plist`
4. Create an APN provider in Stream dashboard, follow this [doc](https://getstream.io/video/docs/flutter/advanced/incoming-calls/providers-configuration/#creating-apns-provider).

## 2. Stream Configuration

The project doesn't contain any Stream credentials. It reads the API key and the user tokens from `env/env.json` when it starts:

| Key | Value |
| --- | --- |
| `STREAM_API_KEY` | Your Stream API key from the [Stream Dashboard](https://dashboard.getstream.io/) |
| `STREAM_IOS_PUSH_PROVIDER` | Name of your APN provider in the Stream Dashboard. Defaults to `apn-flutter-sample` |
| `STREAM_ANDROID_PUSH_PROVIDER` | Name of your Firebase provider in the Stream Dashboard. Defaults to `flutter-firebase` |
| `STREAM_TOKEN_ALICE_JOHNSON` | A user token for `alice_johnson` |
| `STREAM_TOKEN_BOB_SMITH` | A user token for `bob_smith` |
| `STREAM_TOKEN_CHARLIE_BROWN` | A user token for `charlie_brown` |

The quickest way to create it is the generator script in the repository root. It asks for your API key and secret from the [Stream Dashboard](https://dashboard.getstream.io/) and signs the tokens locally. The secret is not stored:

```bash
scripts/generate_env.sh ringing_tutorial
```

The generator script keeps the push provider names from `env/env.example.json`. Change them in `env/env.json` if your providers in the Stream Dashboard are named differently.

Alternatively, copy `env/env.example.json` to `env/env.json` and fill in the values yourself. You can generate user tokens with the [token generator](https://getstream.io/chat/docs/flutter-dart/tokens_and_authentication/#manually-generating-tokens).

Then run the app as usual with `flutter run` or from your IDE. If `env/env.json` is missing values, the app shows a setup screen listing them. `env/env.json` is ignored by git, so your credentials stay out of the repository.

> [!NOTE]
> `env/env.json` is bundled with the app, and tokens created this way don't expire. That's fine for trying the tutorial out, but in a production app, generate tokens on your server.

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
  - Ensure the tokens were generated with the secret of the app whose API key is in `env/env.json`

#### 3. Ringing Functionality Issues
- **Symptoms**: Call notifications not working, ringing not functioning
- **Solutions**:
  - Ensure you're using unique call IDs for each new call (e.g., using UUID)
  - Verify you're not trying to call yourself (same user on different devices)
  - Confirm that call recipients have connected to Stream at least once
  - Check that members exist on Stream's platform
  - Check the provider names in `env/env.json` match the Stream Dashboard
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