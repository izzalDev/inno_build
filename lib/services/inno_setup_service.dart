import 'dart:io';
import 'package:inno_build/models/build_mode.dart';
import 'package:inno_build/models/file_flag.dart';
import 'package:inno_build/models/inno.dart';
import 'package:inno_build/models/language.dart';
import 'package:inno_build/models/run_flag.dart';
import 'package:inno_build/utils/config.dart';
import 'package:inno_build/utils/constants.dart';

import '../utils/iss_generator.dart';

Future<File> buildInnoSetupScript(BuildMode mode) async {
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

Future<Process> compileInnoSetupScript(
  BuildMode mode, {
  bool verbose = false,
}) async {
  Future<Process> result = Process.start(
    innoCompilerPath,
    ['"${mode.installerPath}\\setup_script.iss"'],
    mode: verbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
  );
  return result;
}
