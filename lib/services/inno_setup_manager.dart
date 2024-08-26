// lib/services/inno_setup_manager.dart

import 'dart:io';
import 'package:inno_build/models/build_mode.dart';
import 'package:inno_build/models/file_flag.dart';
import 'package:inno_build/models/inno.dart';
import 'package:inno_build/models/language.dart';
import 'package:inno_build/models/run_flag.dart';
import 'package:inno_build/utils/config.dart';
import 'package:inno_build/utils/constants.dart';
import 'package:inno_build/utils/iss_generator.dart';

class InnoSetupManager {
  final bool quiet;
  final bool verbose;
  final BuildMode mode;

  InnoSetupManager(this.mode, {this.quiet = false, this.verbose = false});

  Future<File> buildInnoSetupScript() async {
    final generator = IssGenerator(
      appId: Config.appId!,
      appName: Config.appName!,
      appVersion: Config.appVersion!,
      defaultDirname: '${Inno.autopf}\\${Config.appName}',
      defaultLanguages: Language.english,
    );

    generator
      ..addFiles(
        '${mode.buildPath}\\*',
        flags: [
          FileFlag.recurseSubdirs,
          FileFlag.createAllSubdirs,
        ],
      )
      ..addFiles(
        vcRedistPath,
        destination: '${Inno.tmp}',
      )
      ..addRun(
        '${Inno.autopf}\\${Config.appName}\\${Config.execName}',
        flags: [
          RunFlag.noWait,
          RunFlag.postInstall,
          RunFlag.skipIfSilent,
        ],
      )
      ..addRun(
        vcRedistPath,
        parameters: '/install /passive /norestart',
        flags: [RunFlag.runHidden],
        message: 'Installing Microsoft Visual C++ 2015-2022 Redistributable...',
      );

    final script = generator.toString();
    final scriptFile = File('${mode.installerPath}/setup_script.iss');
    await scriptFile.writeAsString(script);
    return scriptFile;
  }

  Future<Process> compileInnoSetupScript() async {
    final process = await Process.start(
      innoCompilerPath,
      ['"${mode.installerPath}\\setup_script.iss"'],
      mode: verbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );
    return process;
  }

  Future<Process?> ensureInnoSetupInstalled() async {
    if (!File(innoCompilerPath).existsSync()) {
      final process = await Process.start(
        'cmd',
        [
          '/c',
          innoSetupInstallerPath,
          if (quiet) '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-',
        ],
        mode: quiet ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
      );
      return process;
    }
    return null;
  }
}
