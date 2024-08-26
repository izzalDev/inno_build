import 'dart:io';
import 'package:args/args.dart';
import 'package:cli_spin/cli_spin.dart';
import 'package:inno_build/models/build_mode.dart';
import 'package:inno_build/services/app_id_service.dart';
import 'package:inno_build/services/dependency_manager.dart';
import 'package:inno_build/services/flutter_builder.dart';
import 'package:inno_build/services/inno_setup_manager.dart';
import 'package:inno_build/utils/config.dart';
import 'package:inno_build/utils/constants.dart';
import 'package:inno_build/utils/pubspec_manager.dart';

Future<void> main(List<String> arguments) async {
  late final BuildMode buildMode;
  final parser = ArgParser()
    ..addOption('app-id', abbr: 'a', help: 'Generate a new InnoSetup AppID.')
    ..addFlag('release',
        help: 'Generate the application in release mode (default).')
    ..addFlag('debug',
        abbr: 'd', help: 'Generate the application in debug mode.')
    ..addFlag('install-inno',
        abbr: 'i', help: 'Install Inno Setup if not present.')
    ..addFlag('verbose', abbr: 'v', help: 'Enable verbose output.')
    ..addFlag('quiet', abbr: 'q', help: 'Suppress output (quiet mode).')
    ..addFlag('help', abbr: 'h', help: 'Show this help message.')
    ..addFlag('version', abbr: 'v', help: 'Show version information.');

  final argResults = parser.parse(arguments);

  // MARK: Validate debug and release flags
  if (argResults['debug'] && argResults['release']) {
    print('Error: --release and --debug cannot be used together.');
    exit(64); // Exit code for usage error
  } else if (argResults['debug']) {
    buildMode = BuildMode.debug;
  } else {
    buildMode = BuildMode.release;
  }

  // MARK: Validate verbose and quiet flags
  if (argResults['verbose'] && argResults['quiet']) {
    print('Error: --verbose and --quiet cannot be used together.');
    exit(64); // Exit code for usage error
  }

  if (argResults['help'] as bool) {
    print(helpMessage);
    return;
  }

  if (argResults['version'] as bool) {
    print('Inno Build CLI v1.0.0');
    return;
  }

  final verbose = argResults['verbose'] as bool;
  final quiet = argResults['quiet'] as bool;
  final pubspecManager = PubspecManager();
  final appIdService = AppIdService(pubspecManager);
  final dependencyManager = DependencyManager(verbose: verbose);
  final flutterBuilder = FlutterBuilder(buildMode);
  final innoSetupManager =
      InnoSetupManager(buildMode, verbose: verbose, quiet: quiet);
  final spinner = CliSpin();

  // MARK: Handle App ID generation/update
  if (argResults['app-id'] as bool) {
    spinner.start('Generating new App ID...');
    final newAppId = await appIdService.updateAppId();
    spinner.success('Generated new App ID: $newAppId');
  } else {
    spinner.start('Checking App ID...');
    final appId = await appIdService.ensureAppId();
    spinner.success('Current App ID: $appId');
  }

  // MARK: Check and Install Inno Setup
  spinner.start('Checking Inno Setup...');
  if (File(innoCompilerPath).existsSync()) {
    spinner.success('Inno Setup is already installed.');
  } else {
    spinner.start('Downloading Inno Setup...');
    try {
      dependencyManager.ensureInnoSetupDownloaded();
      spinner.success('Downloaded Inno Setup successfully.');
    } catch (e) {
      spinner.fail('Failed to download Inno Setup: $e');
    }
    spinner.start('Installing Inno Setup...');
    try {
      innoSetupManager.ensureInnoSetupInstalled();
      spinner.success('Installed Inno Setup successfully.');
    } catch (e) {
      spinner.fail('Failed to install Inno Setup: $e');
    }
  }

  // MARK: Build Flutter application
  spinner.start('Building Flutter Windows application...');
  try {
    if (verbose) {
      spinner.stop();
      await flutterBuilder.buildApp();
      spinner.success('Built ${buildMode.buildPath}\\${Config.execName}.');
    } else {
      await flutterBuilder.buildApp();
      spinner.success('Built ${buildMode.buildPath}\\${Config.execName}.');
    }
  } catch (e) {
    spinner.fail('Failed to build Flutter application: $e');
  }

  // MARK: Install Inno Setup
  if (argResults['install-inno'] as bool) {
    if (File(innoSetupInstallerPath).existsSync()) {
      spinner.start('Installing Inno Setup...');
      try {
        innoSetupManager.ensureInnoSetupInstalled();
        spinner.success('Installed Inno Setup successfully.');
      } catch (e) {
        spinner.fail('Failed to install Inno Setup: $e');
      }
    } else {
      spinner.start('Downloading Inno Setup...');
      try {
        dependencyManager.ensureInnoSetupDownloaded();
        spinner.success('Downloaded Inno Setup successfully.');
      } catch (e) {
        spinner.fail('Failed to download Inno Setup: $e');
      }
      spinner.start('Installing Inno Setup...');
      try {
        innoSetupManager.ensureInnoSetupInstalled();
        spinner.success('Installed Inno Setup successfully.');
      } catch (e) {
        spinner.fail('Failed to install Inno Setup: $e');
      }
    }
  }

  // MARK: Build Inno Setup script
  spinner.start('Building Inno Setup script...');
  try {
    File file = await innoSetupManager.buildInnoSetupScript();
    spinner.success('Built ${file.path}.');
  } catch (e) {
    spinner.fail('Failed to build Inno Setup script: $e');
  }

  // MARK: Compile Inno Setup script
  spinner.start('Compiling Inno Setup script...');
  try {
    if (verbose) {
      spinner.stop();
      await innoSetupManager.compileInnoSetupScript();
      spinner.success('Compiled Inno Setup script successfully.');
    } else {
      await innoSetupManager.compileInnoSetupScript();
      spinner.success('Compiled Inno Setup script successfully.');
    }
  } catch (e) {
    spinner.fail('Failed to compile Inno Setup script: $e');
  }
}
