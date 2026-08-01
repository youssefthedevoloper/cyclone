# Cyclone - ProGuard / R8 keep rules

# google_mlkit_text_recognition - keep ML Kit text recognizer classes
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.latin.** { *; }

# google_mlkit_commons
-keep class com.google.mlkit.common.** { *; }

# Google Play Services ML Kit dependencies
-keep class com.google.android.gms.** { *; }

# google_mlkit_text_recognition plugin classes
-keep class com.google_mlkit_text_recognition.** { *; }
-keep class com.google_mlkit_commons.** { *; }

# Keep generic signatures and inner classes for ML Kit
-keepattributes Signature
-keepattributes InnerClasses,EnclosingMethod
-keepattributes *Annotation*
-keepattributes RuntimeVisibleAnnotations,RuntimeVisibleParameterAnnotations,RuntimeVisibleTypeAnnotations

