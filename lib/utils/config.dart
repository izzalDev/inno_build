import 'dart:io';

import 'package:inno_build/utils/pubspec_manager.dart';
import 'package:path/path.dart';

class Config {
  static final PubspecManager _pubspecManager = PubspecManager();
  static final Map<String, dynamic> _pubspec = _pubspecManager.load();
  static String? get appId => _pubspec['inno_build']['app_id'];
  static String? get appVersion => _pubspec['version'].split('+').first;

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

  static String? get bundleId {
    final file = File(join('windows', 'runner', 'Runner.rc'));
    final lines = file.readAsLinesSync();
    final line = lines.firstWhere(
      (line) => line.contains('VALUE "InternalName"'),
      orElse: () => '',
    )..split('VALUE "InternalName", "')[1].split('"')[0].trim();
    return line;
  }

  static get execName {
    return '$bundleId.exe';
  }
}
