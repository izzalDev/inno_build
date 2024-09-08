// Dart imports:
import 'dart:io';
import 'dart:isolate';

// Package imports:
import 'package:path/path.dart';

/// The path where the Flutter Windows application will be built.
///
/// This path is computed by joining the current directory with the
/// directories 'build', 'windows', 'x64', and 'runner'.
///
/// Example: If the current directory is `/Users/username/projects/my_app`,
/// then the `windowsRunnerPath` will be
/// `/Users/username/projects/my_app/build/windows/x64/runner`.
final String windowsRunnerPath = join(
  Directory.current.absolute.path,
  'build',
  'windows',
  'x64',
  'runner',
);

/// The path to the temporary directory.
///
/// This is the directory where the `vc_redist.x64.exe` and
/// `innosetup-6.3.3.exe` files will be downloaded if they are not already
/// present.
///
/// Example: On Windows, this path is likely to be `C:\Users\username\AppData\Local\Temp`.
String tempDir = Directory.systemTemp.path;

/// The path to the "Program Files (x86)" directory.
///
/// This is the directory where Inno Setup will be installed if it is not
/// already present.
///
/// Example: On Windows, this path is likely to be `C:\Program Files (x86)`.
String programfilesDir = Platform.environment['programfiles(x86)']!;

/// The URL from which to download the Visual C++ 2015-2022 Redistributable.
String vcRedistUrl = 'https://aka.ms/vs/17/release/vc_redist.x64.exe';

/// The URL from which to download the Inno Setup installer.
String innoSetupUrl = 'http://files.jrsoftware.org/is/6/innosetup-6.3.3.exe';

/// The path where the `vc_redist.x64.exe` file will be downloaded.
///
/// This path is computed by joining the `tempDir` with the last component of
/// the `vcRedistUrl`.
///
/// Example: If the `tempDir` is `C:\Users\username\AppData\Local\Temp`, then
/// the `vcRedistPath` will be `C:\Users\username\AppData\Local\Temp\vc_redist.x64.exe`.
String vcRedistPath = join(tempDir, vcRedistUrl.split('/').last);

/// The path to the Inno Setup compiler.
///
/// This path is computed by joining the `programfilesDir` with the directories
/// 'Inno Setup 6' and 'ISCC.exe'.
///
/// Example: If the `programfilesDir` is `C:\Program Files (x86)`, then the
/// `innoCompilerPath` will be `C:\Program Files (x86)\Inno Setup 6\ISCC.exe`.
String innoCompilerPath = join(assetsPath!, 'ISCC.exe');

/// The path where the `innosetup-6.3.3.exe` file will be downloaded.
///
/// This path is computed by joining the `tempDir` with the last component of
/// the `innoSetupUrl`.
///
/// Example: If the `tempDir` is `C:\Users\username\AppData\Local\Temp`, then
/// the `innoSetupInstallerPath` will be
/// `C:\Users\username\AppData\Local\Temp\innosetup-6.3.3.exe`.
String innoSetupInstallerPath = join(tempDir, innoSetupUrl.split('/').last);

/// The name of the `vc_redist.x64.exe` file.
String vcRedistExe = 'vc_redist.x64.exe';

/// The help message that will be displayed if the user runs `inno_build -h`.
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

/// The welcome message that will be displayed when the user runs `inno_build`.
const String welcomeMessage = '''
╔════════════════════════════════════════════════════════════════════╗
║                     ✨✨   INNO BUILD   ✨✨                       ║
╚════════════════════════════════════════════════════════════════════╝''';

/// The path to the assets directory.
///
/// This resolves the URI for the `assets` folder within the `inno_build` package
/// and returns its file system path.
String? get assetsPath {
  final packageUri = Uri.parse('package:inno_build/assets');
  final pathFile = Isolate.resolvePackageUriSync(packageUri);
  return pathFile?.toFilePath();
}
