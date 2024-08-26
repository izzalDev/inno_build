import 'dart:io';
import 'package:args/args.dart';
import 'package:cli_spin/cli_spin.dart';
import 'package:inno_build/logic/app_logic.dart';
import 'package:inno_build/models/build_mode.dart';
import 'package:inno_build/services/app_id_service.dart';
import 'package:inno_build/services/dependency_manager.dart';
import 'package:inno_build/services/flutter_builder.dart';
import 'package:inno_build/services/inno_setup_manager.dart';
import 'package:inno_build/utils/constants.dart';
import 'package:inno_build/utils/pubspec_manager.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('app-id', abbr: 'a', help: 'Generate a new InnoSetup AppID.')
    ..addFlag('release', help: 'Generate the application in release mode (default).')
    ..addFlag('debug', abbr: 'd', help: 'Generate the application in debug mode.')
    ..addFlag('install-inno', abbr: 'i', help: 'Install Inno Setup if not present.')
    ..addFlag('verbose', abbr: 'v', help: 'Enable verbose output.')
    ..addFlag('quiet', abbr: 'q', help: 'Suppress output (quiet mode).')
    ..addFlag('help', abbr: 'h', help: 'Show this help message.')
    ..addFlag('version', help: 'Show version information.');

  final argResults = parser.parse(arguments);

  stdout.writeln(welcomeMessage);

  if (argResults['help']) {
    print(helpMessage);
    return;
  }

  if (argResults['version']) {
    print('Inno Build CLI v1.0.0');
    return;
  }

  final verbose = argResults['verbose'];
  final quiet = argResults['quiet'];

  if (verbose && quiet) {
    print('Error: --verbose and --quiet cannot be used together.');
    exit(64); // Exit code for usage error
  }

  final buildMode = _determineBuildMode(argResults);

  final pubspecManager = PubspecManager();
  final appIdService = AppIdService(pubspecManager);
  final dependencyManager = DependencyManager(verbose: verbose);
  final flutterBuilder = FlutterBuilder(buildMode);
  final innoSetupManager = InnoSetupManager(buildMode, verbose: verbose, quiet: quiet);
  final spinner = CliSpin();

  final appLogic = AppLogic(
    argResults: argResults,
    pubspecManager: pubspecManager,
    appIdService: appIdService,
    dependencyManager: dependencyManager,
    flutterBuilder: flutterBuilder,
    innoSetupManager: innoSetupManager,
    spinner: spinner,
    buildMode: buildMode,
  );

  try {
    await appLogic.run();
  } catch (e) {
    print(e);
    exit(64); // Exit code for usage error
  }
}

BuildMode _determineBuildMode(ArgResults argResults) {
  if (argResults['debug']) {
    if (argResults['release']) {
      print('Error: --release and --debug cannot be used together.');
      exit(64); // Exit code for usage error
    }
    return BuildMode.debug;
  }
  return BuildMode.release;
}
