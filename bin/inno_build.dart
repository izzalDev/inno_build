// Dart imports:
import 'dart:io';

// Package imports:
import 'package:args/args.dart';
import 'package:cli_spin/cli_spin.dart';
// Project imports:
import 'package:inno_build/inno_build.dart';
import 'package:inno_build/models/build_mode.dart';
import 'package:inno_build/services/app_id_service.dart';
import 'package:inno_build/services/dependency_manager.dart';
import 'package:inno_build/services/inno_setup_manager.dart';
import 'package:inno_build/utils/constants.dart';
import 'package:inno_build/utils/pubspec_manager.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('app-id', abbr: 'a', help: 'Generate a new InnoSetup AppID.')
    ..addFlag('release',
        help: 'Generate the application in release mode (default).')
    ..addFlag('debug',
        abbr: 'd', help: 'Generate the application in debug mode.')
    ..addFlag('install-inno',
        abbr: 'i', help: 'Install Inno Setup if not present.')
    ..addFlag('skip-flutter-build', help: 'Skip the Flutter build step.')
    ..addFlag('help', abbr: 'h', help: 'Show this help message.')
    ..addFlag('version', help: 'Show version information.')

    ..addFlag('obfuscate', help: 'Obfuscate the Dart code during the build.')
    ..addOption('split-debug-info', help: 'Path to store split debug info files.')
    ..addMultiOption('dart-define', help: 'Pass additional key-value pairs to the Dart compiler.')
    ..addOption('target', abbr: 't', help: 'The main entry-point file of the application.')

    ..addFlag('verbose', abbr: 'v', help: 'Enable verbose output.')
    ..addFlag('quiet', abbr: 'q', help: 'Suppress output (quiet mode).');

  final argResults = parser.parse(arguments);

  stdout.writeln(welcomeMessage);

  if (argResults['help']) {
    print(parser.usage);
    return;
  }

  if (argResults['version']) {
    print('inno_build v1.0.0');
    return;
  }

  final verbose = argResults['verbose'];
  final quiet = argResults['quiet'];

  if (verbose && quiet) {
    print('Error: --verbose and --quiet cannot be used together.');
    exit(64); // Exit code for usage error
  }

  final buildMode = _determineBuildMode(argResults);

  // Servislerin oluşturulması
  final pubspecManager = PubspecManager();
  final appIdService = AppIdService(pubspecManager);
  final dependencyManager = DependencyManager(verbose: verbose);
  final innoSetupManager =
  InnoSetupManager(buildMode, verbose: verbose, quiet: quiet);
  final spinner = CliSpin(isSilent: quiet);

  final appLogic = InnoBuild(
    argResults: argResults,
    pubspecManager: pubspecManager,
    appIdService: appIdService,
    dependencyManager: dependencyManager,
    innoSetupManager: innoSetupManager,
    spinner: spinner,
    buildMode: buildMode,
  );

  try {
    await appLogic.run();
  } catch (e) {
    print('An error occurred: $e');
    exit(1);
  }
}

BuildMode _determineBuildMode(ArgResults argResults) {
  if (argResults['debug']) {
    if (argResults['release']) {
      print('Error: --release and --debug cannot be used together.');
      exit(64);
    }
    return BuildMode.debug;
  }
  return BuildMode.release;
}