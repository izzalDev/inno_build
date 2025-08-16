// lib/inno_build.dart

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:args/args.dart';
import 'package:cli_spin/cli_spin.dart';

// Project imports:
import 'package:inno_build/models/build_mode.dart';
import 'package:inno_build/services/app_id_service.dart';
import 'package:inno_build/services/dependency_manager.dart';
import 'package:inno_build/services/flutter_builder.dart';
import 'package:inno_build/services/inno_setup_manager.dart';
import 'package:inno_build/utils/config.dart';
import 'package:inno_build/utils/constants.dart';
import 'package:inno_build/utils/pubspec_manager.dart';

/// A list of command-line options that should be passed through to the
/// `flutter build` command. To add support for a new flutter build argument,
/// add it to this list and also to the ArgParser in your main executable file.
const List<String> _flutterBuildOptions = [
  'obfuscate',
  'split-debug-info',
  'dart-define',
  'target',
  'verbose',
  'quiet',
  // Future Flutter build arguments can be added here.
  // e.g., 'tree-shake-icons', 'build-name', 'build-number'
];

/// This class is the main entry point of the `inno_build` command-line tool.
///
/// It takes the parsed command-line arguments, and uses them to determine what
/// actions to take. The actions are:
/// 1. Generate a new App ID if the user specified the `--app-id` flag.
/// 2. Build the Flutter Windows application using the `flutter build` command.
/// 3. Build the Inno Setup script using the `inno_setup_manager` service.
/// 4. Compile the Inno Setup script using the `inno_setup_manager` service.
class InnoBuild {
  /// The parsed command-line arguments.
  final ArgResults argResults;

  /// An instance of the `PubspecManager` class.
  final PubspecManager pubspecManager;

  /// An instance of the `AppIdService` class.
  final AppIdService appIdService;

  /// An instance of the `DependencyManager` class.
  final DependencyManager dependencyManager;

  /// An instance of the `InnoSetupManager` class.
  final InnoSetupManager innoSetupManager;

  /// An instance of the `CliSpin` class.
  final CliSpin spinner;

  /// The build mode specified by the user.
  final BuildMode buildMode;

  /// Creates an instance of the `inno_build` command-line tool.
  ///
  /// The [argResults] parameter is the parsed command-line arguments.
  /// The [pubspecManager] parameter is an instance of the `PubspecManager`.
  /// The [appIdService] parameter is an instance of the `AppIdService`.
  /// The [dependencyManager] parameter is an instance of the `DependencyManager`.
  /// The [innoSetupManager] parameter is an instance of the `InnoSetupManager`.
  /// The [spinner] parameter is an instance of the `CliSpin` class.
  /// The [buildMode] parameter is the build mode that the user specified.
  InnoBuild({
    required this.argResults,
    required this.pubspecManager,
    required this.appIdService,
    required this.dependencyManager,
    required this.innoSetupManager,
    required this.spinner,
    required this.buildMode,
  });

  /// Runs the `inno_build` command-line tool.
  ///
  /// This method takes no arguments and returns a `Future` that completes when
  /// the tool has finished running.
  Future<void> run() async {
    _validateFlags();
    if (argResults['install-inno']) {
      await _installInnoSetup();
      exit(0);
    }
    await _handleAppId();
    if (!argResults['skip-flutter-build']) {
      await _buildFlutterApp();
    }
    await _buildInnoSetupScript();
    await _compileInnoSetupScript();
  }

  /// Validates the command-line flags.
  ///
  /// This method is called by the `run` method and checks that the user has not
  /// provided any invalid combinations of flags.
  void _validateFlags() {
    if (argResults['debug'] &&
        argResults['release'] &&
        argResults['install-inno']) {
      throw ArgumentError(
          'Error: --release, --debug, and --install-inno cannot be used together.');
    }
    if (argResults['verbose'] && argResults['quiet']) {
      throw ArgumentError(
          'Error: --verbose and --quiet cannot be used together.');
    }
  }

  /// Collects all relevant arguments from argResults to be passed to Flutter.
  Map<String, dynamic> _getFlutterBuildArgs() {
    final args = <String, dynamic>{};
    for (final option in _flutterBuildOptions) {
      if (argResults.wasParsed(option)) {
        args[option] = argResults[option];
      }
    }
    return args;
  }

  /// Handles generating a new App ID if the user specified the `--app-id` flag.
  ///
  /// This method is called by the `run` method and checks if the user has
  /// specified the `--app-id` flag. If so, it generates a new App ID and updates
  /// the `pubspec.yaml` file with it.
  Future<void> _handleAppId() async {
    if (argResults['app-id'] != null) {
      spinner.start('Generating new App ID...');
      try {
        final newAppId = await appIdService.updateAppId();
        spinner.success('Generated new App ID: $newAppId');
      } catch (e) {
        spinner.fail('Failed to generate new App ID');
        stderr.writeln(e);
      }
    } else {
      spinner.start('Checking App ID...');
      try {
        final appId = await appIdService.ensureAppId();
        spinner.success('Current App ID: $appId');
      } catch (e) {
        spinner.fail('Failed to check App ID');
        stderr.writeln(e);
      }
    }
  }

  /// Builds the Flutter Windows application using the `flutter build` command.
  ///
  /// This method is called by the `run` method and builds the Flutter Windows
  /// application using the `flutter build` command.
  Future<void> _buildFlutterApp() async {
    spinner.start('Building Flutter Windows application...');

    // Create a FlutterBuilder instance with the dynamic arguments.
    final flutterBuilder = FlutterBuilder(
      buildMode: buildMode,
      flutterBuildArgs: _getFlutterBuildArgs(),
    );

    if (argResults['verbose']) spinner.stopAndPersist();

    final exitCode = await flutterBuilder.buildApp();

    if (exitCode == 0) {
      spinner.success('Built ${buildMode.buildPath}\\${Config.execName}.');
    } else {
      spinner.fail(
          'Failed to build Flutter application. Check the logs above for details.');
    }
  }

  /// Downloads Inno Setup if it is not already installed.
  ///
  /// This method is called by the `run` method and downloads Inno Setup if it is
  /// not already installed.
  Future<void> _downloadInnoSetup() async {
    spinner.start('Downloading Inno Setup...');
    final download = await dependencyManager.ensureInnoSetupDownloaded();
    if (download == 0) {
      spinner.success('Downloaded Inno Setup successfully.');
      spinner.start('Installing Inno Setup...');
    } else {
      spinner.fail('Failed to download Inno Setup');
    }
  }

  /// Installs Inno Setup if it is not already installed.
  ///
  /// This method is called by the `run` method and installs Inno Setup if it is
  /// not already installed.
  Future<void> _installInnoSetup() async {
    if (File(innoSetupInstallerPath).existsSync()) {
      spinner.start('Installing Inno Setup...');
      try {
        await innoSetupManager.installInnoSetup();
        spinner.success('Installed Inno Setup successfully.');
      } catch (e) {
        spinner.fail('Failed to install Inno Setup');
        stderr.writeln(e);
      }
    } else {
      await _downloadInnoSetup();
      final install = await innoSetupManager.installInnoSetup();
      if (install == 0) {
        spinner.success('Installed Inno Setup successfully.');
      } else {
        spinner.fail('Failed to install Inno Setup');
      }
    }
  }

  /// Builds the Inno Setup script using the `inno_setup_manager` service.
  ///
  /// This method is called by the `run` method and builds the Inno Setup script
  /// using the `inno_setup_manager` service.
  Future<void> _buildInnoSetupScript() async {
    spinner.start('Building Inno Setup script...');
    try {
      final file = await innoSetupManager.buildInnoSetupScript();
      spinner.success('Built ${file.path}.');
    } catch (e) {
      spinner.fail('Failed to build Inno Setup script');
      stderr.writeln(e);
    }
  }

  /// Compiles the Inno Setup script using the `inno_setup_manager` service.
  ///
  /// This method is called by the `run` method and compiles the Inno Setup script
  /// using the `inno_setup_manager` service.
  Future<void> _compileInnoSetupScript() async {
    spinner.start('Compiling Inno Setup script...');
    if (argResults['verbose']) {
      spinner.stopAndPersist();
    }
    final exitCode = await innoSetupManager.compileInnoSetupScript();
    if (exitCode == 0) {
      spinner.success('Built ${buildMode.installerPath}\\installer.exe.');
    } else {
      spinner.fail('Failed to compile Inno Setup script');
    }
  }
}
