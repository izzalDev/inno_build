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

/// Builds an Inno Setup script and compiles it into a Windows executable.
class InnoSetupManager {
  /// Whether to display no output at all.
  final bool quiet;

  /// Whether to display detailed information about the build process.
  final bool verbose;

  /// The build mode to use.
  final BuildMode mode;

  /// Creates a new instance of the [InnoSetupManager] class.
  InnoSetupManager(this.mode, {this.quiet = false, this.verbose = false});

  /// Builds an Inno Setup script and saves it to a file.
  ///
  /// The file will be saved in the [BuildMode.installerPath] directory and will
  /// have the name `setup_script.iss`.
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
        key: 'OutputDir',
        value: mode.installerPath,
      )
      ..addSetup(
        key: 'OutputBaseFilename',
        value: 'installer',
      )
      ..addSetup(
        key: 'MinVersion',
        value: '10.0.10240',
      )
      ..addFiles(
        source: '${mode.buildPath}\\*',
        flags: [FileFlag.recurseSubdirs, FileFlag.createAllSubdirs],
      )
      // ..addFiles(
      //   source: vcRedistPath,
      //   destination: '${Inno.tmp}',
      // )
      ..addRun(
        fileName: '${Inno.autopf}\\${Config.appName}\\${Config.execName}',
        flags: [RunFlag.postInstall, RunFlag.skipIfSilent],
        description: '{cm:LaunchProgram,${Config.appName}}',
      )
      // ..addRun(
      //   fileName: '${Inno.tmp}\\$vcRedistExe',
      //   parameters: '/install /passive /norestart',
      //   flags: [RunFlag.runHidden],
      //   message: 'Installing Microsoft Visual C++ 2015-2022 Redistributable...',
      // )
      ..addIcons(
        name: '${Inno.autoprograms}\\${Config.appName}',
        fileName: '${Inno.app}\\${Config.bundleId}.exe',
      )
      ..addIcons(
        name: '${Inno.autodesktop}\\${Config.appName}',
        fileName: '${Inno.app}\\${Config.bundleId}',
        tasks: ['desktopicon'],
      )
      ..addTasks(
        name: 'desktopicon',
        description: '{cm:CreateDesktopIcon}',
        groupDescription: '{cm:AdditionalIcons}',
        flags: [TaskFlag.unchecked],
      )
      ..addSetup(
        key: 'UninstallDisplayIcon',
        value: '${Inno.app}\\${Config.execName}',
      )
      ..addSetup(
        key: 'UninstallDisplayName',
        value: '${Config.appName}',
      )
      ..addSetup(
        key: 'DisableWelcomePage',
        value: 'no',
      )
      ..addSetup(
        key: 'WizardImageFile',
        value: join(assetsPath!, 'WizImage.bmp'),
      )
      ..addSetup(
        key: 'WizardSmallImageFile',
        value: join(assetsPath!, 'WizSmallImage.bmp'),
      )
      ..addSetup(
        key: 'SetupIconFile',
        value: join(assetsPath!, 'SetupIcon.ico'),
      )
      ..addSetup(
        key: 'PrivilegesRequiredOverridesAllowed',
        value: 'dialog',
      )
      ..addFiles(
        source: join(assetsPath!, 'msvcp140.dll'),
      )
      ..addFiles(
        source: join(assetsPath!, 'vcruntime140.dll'),
      )
      ..addFiles(
        source: join(assetsPath!, 'vcruntime140_1.dll'),
      );

    if (File('LICENSE').existsSync()) {
      generator.addSetup(
        key: 'LicenseFile',
        value: join(Directory.current.path, 'LICENSE'),
      );
    }

    final script = generator.toString();
    final scriptPath = join(mode.installerPath, 'setup_script.iss');
    final scriptFile = File(scriptPath);
    await scriptFile.writeAsString(script);
    return scriptFile;
  }

  /// Compiles the Inno Setup script into a Windows executable.
  ///
  /// The script will be compiled using the Inno Setup compiler specified in the
  /// `innoCompilerPath` constant.
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

  /// Installs the Inno Setup compiler.
  ///
  /// The installer will be run in silent mode and will not restart the computer.
  Future<int> installInnoSetup() async {
    final args = [
      '/c',
      innoSetupInstallerPath,
      '/VERYSILENT',
      '/SUPPRESSMSGBOXES',
      '/NORESTART',
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
