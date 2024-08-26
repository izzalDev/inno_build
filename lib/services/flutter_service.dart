import 'dart:io';

import 'package:inno_build/models/build_mode.dart';

Future<Process> buildFlutterApp(
  BuildMode buildMode, {
  bool verbose = false,
}) async {
  final mode = buildMode.name;
  print('Building Flutter app in $mode mode...');

  Future<Process> result = Process.start(
    'flutter',
    ['build', 'windows', '--$mode'],
    mode: verbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
  );
  return result;
}
