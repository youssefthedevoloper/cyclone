# Keep ML Kit Vision Text classes used via reflection or optional modules
# Prevent R8 from removing language-specific text recognizers and options
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }

# Keep Flutter plugin entry points that may be accessed reflectively
-keep class com.google_mlkit_text_recognition.** { *; }

# If you still see missing classes, inspect the generated file:
# build/app/outputs/mapping/release/missing_rules.txt and add the suggested keep rules.
