# Flutter core classes
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.app.** { *; }

-keep class io.getstream.video.flutter.stream_video_push_notification.** { *; }

# Suppress warnings for common missing classes
-dontwarn java.beans.ConstructorProperties
-dontwarn java.beans.Transient
-dontwarn org.conscrypt.**
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry
-dontwarn com.google.android.play.core.**
