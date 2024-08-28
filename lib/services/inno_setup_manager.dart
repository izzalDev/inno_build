// lib/services/inno_setup_manager.dart

import 'dart:io';
import 'package:inno_build/models/build_mode.dart';
import 'package:inno_build/models/file_flag.dart';
import 'package:inno_build/models/inno.dart';
import 'package:inno_build/models/language.dart';
import 'package:inno_build/models/run_flag.dart';
import 'package:inno_build/models/task_flag.dart';
import 'package:inno_build/utils/config.dart';
import 'package:inno_build/utils/constants.dart';
import 'package:inno_build/utils/iss_generator.dart';
import 'package:path/path.dart';

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
      ..addSetup(
        'OutputDir',
        mode.installerPath,
      )
      ..addSetup(
        'OutputBaseFilename',
        'installer',
      )
      ..addSetup(
        'MinVersion',
        '10.0.10240',
      )
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
          RunFlag.postInstall,
          RunFlag.skipIfSilent,
        ],
      )
      ..addRun(
        '${Inno.tmp}\\$vcRedistExe',
        parameters: '/install /passive /norestart',
        flags: [RunFlag.runHidden],
        message: 'Installing Microsoft Visual C++ 2015-2022 Redistributable...',
      )
      ..addIcons(
        '${Inno.autoprograms}\\${Config.appName}',
        '${Inno.app}\\${Config.bundleId}.exe',
      )
      ..addIcons(
        '${Inno.autodesktop}\\${Config.appName}',
        '${Inno.app}\\${Config.bundleId}',
        tasks: ['desktopicon'],
      )
      ..addTasks(
        name: 'desktopicon',
        description: '{cm:CreateDesktopIcon}',
        groupDescription: '{cm:AdditionalIcons}',
        flags: [TaskFlag.unchecked],
      )
      ..addSetup(
        'UninstallDisplayIcon',
        '${Inno.app}\\${Config.execName}',
      )
      ..addSetup(
        'UninstallDisplayName',
        '${Config.appName}',
      );

    final script = generator.toString();
    final scriptPath = join(mode.installerPath, 'setup_script.iss');
    final scriptFile = File(scriptPath);
    await scriptFile.writeAsString(script);
    return scriptFile;
  }

  Future<int> compileInnoSetupScript() async {
    List<String> args = ['-Q', '${mode.installerPath}\\setup_script.iss'];
    final process = await Process.start(
      innoCompilerPath,
      verbose ? args.sublist(1) : args,
      runInShell: true,
      mode: verbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );
    return process.exitCode;
  }

  Future<int> installInnoSetup() async {
    final args = [
      '/c',
      innoSetupInstallerPath,
      '/VERYSILENT',
      '/SUPPRESSMSGBOXES',
      '/NORESTART',
      '/CURRENTUSER',
      '/SP-',
    ];

    final process = await Process.start(
      'cmd',
      args,
      mode: quiet ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );

    return await process.exitCode;
  }
}
