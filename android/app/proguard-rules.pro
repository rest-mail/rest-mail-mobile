# R8 keeps only what it can see being used. Everything below is reached by
# reflection or from native code, so R8 cannot see it and would strip it — the app
# then builds cleanly and dies at runtime, which is the worst way to find out.

# Flutter's Android embedding is instantiated from the manifest and called from
# the engine's native side; plugin classes are looked up by name at registration.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Kotlin coroutines' service loader entries and the JVM metadata annotations that
# some plugins read at runtime.
-keepattributes *Annotation*, InnerClasses, Signature, RuntimeVisible*Annotations
-dontwarn kotlinx.coroutines.**

# Stack traces from a shrunk build are unreadable without line numbers; keeping
# them costs nothing and the source file name is hidden separately.
-keepattributes SourceFile, LineNumberTable
-renamesourcefileattribute SourceFile
