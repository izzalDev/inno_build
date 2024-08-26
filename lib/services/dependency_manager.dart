// lib/services/dependency_manager.dart

import 'dart:io';
import 'package:inno_build/utils/constants.dart';

class DependencyManager {
  final bool verbose;

  DependencyManager({this.verbose = false});

  Future<int> ensureVcredistDownloaded() async {
    // Implementasi untuk memeriksa dan mendownload vcredist
    if (!File(vcRedistPath).existsSync()) {
      final process = await Process.start(
        'curl',
        ['-L', vcRedistUrl, '-o', vcRedistPath],
        runInShell: true,
        mode: verbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
      );
      return process.exitCode;
    }
    return 0;
  }

  Future<int> ensureInnoSetupDownloaded() async {
    if (!File(innoSetupInstallerPath).existsSync()) {
      final process = await Process.start(
        'curl',
        ['-L', innoSetupUrl, '-o', innoSetupInstallerPath],
        runInShell: true,
        mode: verbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
      );
      return process.exitCode;
    }
    return 0;
  }
}
