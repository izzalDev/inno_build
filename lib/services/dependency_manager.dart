// lib/services/dependency_manager.dart

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:inno_build/utils/constants.dart';

/// DependencyManager is a class that is responsible for downloading and
/// installing all the dependencies required to build the installer.
class DependencyManager {
  /// Whether to print all the output of the command.
  ///
  /// Defaults to `false`.
  final bool verbose;

  /// Creates a new DependencyManager.
  DependencyManager({this.verbose = false});

  /// Downloads and installs Visual C++ 2015-2022 Redistributable.
  ///
  /// If the file already exists, it will not be downloaded.
  ///
  /// Returns the exit code of the command.
  Future<int> ensureVcredistDownloaded() async {
    // Implementasi untuk memeriksa dan mendownload vcredist
    if (!File(vcRedistPath).existsSync()) {
      final process = await Process.start(
        'curl',
        ['-L', '-s', vcRedistUrl, '-o', vcRedistPath],
        runInShell: true,
      );
      return process.exitCode;
    }
    return 0;
  }

  /// Downloads and installs Inno Setup.
  ///
  /// If the file already exists, it will not be downloaded.
  ///
  /// Returns the exit code of the command.
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
