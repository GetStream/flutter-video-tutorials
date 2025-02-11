-dontwarn java.beans.ConstructorProperties
-dontwarn java.beans.Transient
-dontwarn org.conscrypt.Conscrypt
-dontwarn org.conscrypt.OpenSSLProvider
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry

-keepattributes *Annotation*

# Keep Java Beans Annotations
-keep class java.beans.** { *; }

# Keep Jackson Databind
-keep class com.fasterxml.jackson.databind.** { *; }
-keep class com.fasterxml.jackson.core.** { *; }
-keep class com.fasterxml.jackson.** { *; }

# Keep Conscrypt classes (for OkHttp)
-keep class org.conscrypt.** { *; }

# Keep DOMImplementationRegistry
-keep class org.w3c.dom.bootstrap.DOMImplementationRegistry { *; }
