import 'dart:io';

import 'package:path/path.dart';

final windowsRunnerPath = join(
  Directory.current.absolute.path,
  'build',
  'windows',
  'x64',
  'runner',
);
String tempDir = Directory.systemTemp.path;
String programfilesDir = Platform.environment['programfiles(x86)']!;
String homeDir = Platform.environment['homepath']!;
String vcRedistUrl = 'https://aka.ms/vs/17/release/vc_redist.x64.exe';
String innoSetupUrl = 'http://files.jrsoftware.org/is/6/innosetup-6.3.3.exe';
String vcRedistPath = join(tempDir, vcRedistUrl.split('/').last);
String innoCompilerPath = join(homeDir,'AppData','Local','Programs','Inno Setup 6','ISCC.exe');
String innoSetupInstallerPath = join(tempDir, innoSetupUrl.split('/').last);
String vcRedistExe = 'vc_redist.x64.exe';

const String helpMessage = '''
Usage: inno_build [options]
Options (for generate command):
  -a, --app-id              Generate a new InnoSetup AppID.
      --release             Generate the application in release mode (default).
  -d, --debug               Generate the application in debug mode.

Global Options:
  -h, --help                Show this help message.
  -v, --version             Show version information.
      --verbose             Enable verbose output.
  -q, --quiet               Suppress output (quiet mode).
  -i, --install             Install Inno Setup if not already installed.
''';

const String welcomeMessage = '''
╔════════════════════════════════════════════════════════════════════╗
║                     ✨✨   INNO BUILD   ✨✨                       ║ 
╚════════════════════════════════════════════════════════════════════╝''';
