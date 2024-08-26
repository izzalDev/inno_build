// lib/services/flutter_builder.dart

import 'dart:io';
import 'package:inno_build/models/build_mode.dart';

class FlutterBuilder {
  final bool verbose;
  final BuildMode buildMode;

  FlutterBuilder(this.buildMode, {this.verbose = false});

  Future<Process> buildApp() async {
    final mode = buildMode.name;
    final process = await Process.start(
      'flutter',
      ['build', 'windows', '--$mode'],
      mode: verbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );
    return process;
  }
}

