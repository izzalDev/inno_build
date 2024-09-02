import 'dart:io';

import 'package:inno_build/utils/pubspec_manager.dart';
import 'package:path/path.dart';

/// Holds the configuration for the build process.
///
/// This class reads the configuration from the pubspec.yaml file.
/// The configuration is cached for performance reasons.
class Config {
  /// The PubspecManager that is used to read the pubspec.yaml file.
  static final PubspecManager _pubspecManager = PubspecManager();

  /// The configuration that is read from the pubspec.yaml file.
  static final Map<String, dynamic> _pubspec = _pubspecManager.load();

  /// The application id.
  ///
  /// This is read from the `inno_build.app_id` key in the pubspec.yaml file.
  static String? get appId => _pubspec['inno_build']['app_id'];

  /// The application version.
  ///
  /// This is read from the `version` key in the pubspec.yaml file.
  static String? get appVersion => _pubspec['version'].split('+').first;

  /// The application name.
  ///
  /// This is read from the `window.CreateAndShow` or `window.Create` line
  /// in the windows/runner/main.cpp file.
  static String? get appName {
    final file = File(join('windows', 'runner', 'main.cpp'));
    final lines = file.readAsLinesSync();
    final line = lines.firstWhere(
      (line) =>
          line.contains('window.CreateAndShow') ||
          line.contains('window.Create'),
      orElse: () => '',
    );
    final match = RegExp(r'(CreateAndShow|Create)\(L"(.*?)"').firstMatch(line);
    return match?.group(2)?.trim();
  }

  /// The application bundle id.
  ///
  /// This is read from the `windows/runner/Runner.rc` file.
  static String? get bundleId {
    try {
      final file = File(join('windows', 'runner', 'Runner.rc'));
      return file
          .readAsLinesSync()
          .firstWhere(
            (line) => line.contains('VALUE "InternalName"'),
            orElse: () => '',
          )
          .split('VALUE "InternalName", "')[1]
          .split('"')[0]
          .trim();
    } catch (e) {
      print('Error reading file: $e');
      return null;
    }
  }

  /// The executable name for the application.
  ///
  /// This is the bundle id with the `.exe` extension.
  static String get execName => '$bundleId.exe';
}
