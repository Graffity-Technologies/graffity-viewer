# Keep all okhttp3 internal platform-related classes
-keep class okhttp3.internal.platform.** { *; }

# Optional: if using BouncyCastle, Conscrypt, or OpenJSSE
-keep class org.bouncycastle.** { *; }
-keep class org.conscrypt.** { *; }
-keep class org.openjsse.** { *; }

-keep class io.grpc.graffity.** { *; }
-keepclassmembers class io.grpc.graffity.** { *; }
-keep class com.google.protobuf.** { *; }