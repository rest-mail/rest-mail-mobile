/// The app's version: the build's `--build-name`, which is pubspec.yaml's
/// `version` unless a release overrides it, and "dev" when nothing passes one
/// (as under `flutter test`).
///
/// A release passes its tag's version (testflight.yml), so testers see the
/// version that was tagged.
const appVersion = String.fromEnvironment(
  'FLUTTER_BUILD_NAME',
  defaultValue: 'dev',
);
