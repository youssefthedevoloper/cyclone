# CI Build Fix - APK Release

## Steps
- [x] Push all project files to GitHub
- [x] Fix empty asset directories (add .gitkeep to assets/lottie and assets/icons)
- [x] Create proguard-rules.pro with ML Kit R8 keep rules
- [x] Wire ProGuard config into android/app/build.gradle.kts
- [x] Add ML Kit language module implementation dependencies (chinese/japanese/korean/devanagari) to android/app/build.gradle.kts
- [x] Reduce Gradle JVM heap in android/gradle.properties to fit GitHub Actions 7GB runners
- [x] Add -dontwarn for com.google.mlkit.vision.text.** to proguard-rules.pro
- [x] Add actions/setup-java (Temurin 17) to android-apk.yml workflow
- [x] Commit and push fixes to trigger CI rebuild (commit 42029c2)
- [ ] Verify CI APK build succeeds (check GitHub Actions tab)

## Notes
- CI failed on `flutter build apk --release`:
  - Error 1: `unable to find directory entry in pubspec.yaml: assets/lottie/` and `assets/icons/` (empty dirs not tracked by git)
  - Error 2: R8 missing classes for `com.google.mlkit.vision.text.*` (needs keep rules)
  - Error 3: ML Kit plugin uses `compileOnly` for language modules but imports them directly → need `implementation` deps
  - Error 4: Gradle `-Xmx8G` exceeds GitHub Actions 7GB RAM → OOM during R8

