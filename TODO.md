# CI Build Fix - APK Release

## Steps
- [x] Push all project files to GitHub
- [x] Fix empty asset directories (add .gitkeep to assets/lottie and assets/icons)
- [x] Create proguard-rules.pro with ML Kit R8 keep rules
- [x] Wire ProGuard config into android/app/build.gradle.kts
- [x] Commit and push fixes to trigger CI rebuild
- [ ] Verify CI APK build succeeds (GitHub Actions auto-runs on push)

## Notes
- CI failed on `flutter build apk --release`:
  - Error 1: `unable to find directory entry in pubspec.yaml: assets/lottie/` and `assets/icons/` (empty dirs not tracked by git)
  - Error 2: R8 missing classes for `com.google.mlkit.vision.text.*` (needs keep rules)

