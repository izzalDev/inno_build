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

/// This class is the main entry point of the `inno_build` command-line tool.
///
/// It takes the parsed command-line arguments, and uses them to determine what
/// actions to take. The actions are:
/// 1. Generate a new App ID if the user specified the `--app-id` flag.
/// 2. Check if Inno Setup is installed, and download and install it if not.
/// 3. Check if the Visual C++ 2015-2022 Redistributable is downloaded, and
/// download it if not.
/// 4. Build the Flutter Windows application using the `flutter build` command.
/// 5. Build the Inno Setup script using the `inno_setup_manager` service.
/// 6. Compile the Inno Setup script using the `inno_setup_manager` service.
class InnoBuild {
  /// The parsed command-line arguments.
  ///
  /// This is used to determine the actions to take when running the `inno_build`
  /// command-line tool.
  final ArgResults argResults;

  /// An instance of the `PubspecManager` class.
  ///
  /// This is used to read and write the `pubspec.yaml` file.
  final PubspecManager pubspecManager;

  /// An instance of the `AppIdService` class.
  ///
  /// This is used to generate a new App ID if the user specified the
  /// `--app-id` flag.
  final AppIdService appIdService;

  /// An instance of the `DependencyManager` class.
  ///
  /// This is used to download and install Inno Setup if it is not already
  /// installed, and to download the Visual C++ 2015-2022 Redistributable if
  /// it is not already downloaded.
  final DependencyManager dependencyManager;

  /// An instance of the `FlutterBuilder` class.
  ///
  /// This is used to build the Flutter Windows application using the
  /// `flutter build` command.
  final FlutterBuilder flutterBuilder;

  /// An instance of the `InnoSetupManager` class.
  ///
  /// This is used to build the Inno Setup script and compile it using the
  /// `inno_setup_manager` service.
  final InnoSetupManager innoSetupManager;

  /// An instance of the `CliSpin` class.
  ///
  /// This is used to display a spinner while the `inno_build` command-line tool
  /// is running.
  final CliSpin spinner;

  /// The build mode specified by the user.
  ///
  /// This is either `BuildMode.debug` or `BuildMode.release`.
  final BuildMode buildMode;

  /// Creates an instance of the `inno_build` command-line tool.
  ///
  /// The [argResults] parameter is the parsed command-line arguments.
  ///
  /// The [pubspecManager] parameter is an instance of the `PubspecManager`
  /// class, which is used to read and write the `pubspec.yaml` file.
  ///
  /// The [appIdService] parameter is an instance of the `AppIdService` class,
  /// which is used to generate a new App ID if the user specified the
  /// `--app-id` flag.
  ///
  /// The [dependencyManager] parameter is an instance of the
  /// `DependencyManager` class, which is used to check if Inno Setup is
  /// installed, and download and install it if not.
  ///
  /// The [flutterBuilder] parameter is an instance of the `FlutterBuilder`
  /// class, which is used to build the Flutter Windows application using
  /// the `flutter build` command.
  ///
  /// The [innoSetupManager] parameter is an instance of the `InnoSetupManager`
  /// class, which is used to build the Inno Setup script and compile it.
  ///
  /// The [spinner] parameter is an instance of the `CliSpin` class, which is
  /// used to display a spinner on the console.
  ///
  /// The [buildMode] parameter is the build mode that the user specified using
  /// the `--debug` or `--release` flag.
  InnoBuild({
    required this.argResults,
    required this.pubspecManager,
    required this.appIdService,
    required this.dependencyManager,
    required this.flutterBuilder,
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
    // await _checkAndInstallInnoSetup();
    // await _checkAndDownloadVccRedist();
    await _buildFlutterApp();
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
      throw ArgumentError('Error: --verbose --quiet cannot be used together.');
    }
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

  /// Checks if Inno Setup is installed, and downloads and installs it if not.
  ///
  /// This method is called by the `run` method and checks if Inno Setup is
  /// installed. If not, it downloads and installs it.
  // Future<void> _checkAndInstallInnoSetup() async {
  //   spinner.start('Checking Inno Setup...');
  //   if (File(innoCompilerPath).existsSync()) {
  //     spinner.success('Inno Setup is already installed.');
  //   } else {
  //     await _installInnoSetup();
  //   }
  // }

  /// Checks if the Visual C++ 2015-2022 Redistributable is downloaded, and
  /// downloads it if not.
  ///
  /// This method is called by the `run` method and checks if the Visual C++
  /// 2015-2022 Redistributable is downloaded. If not, it downloads it.
  // Future<void> _checkAndDownloadVccRedist() async {
  //   spinner.start('Checking Visual C++ 2015-2022 Redistributable...');
  //   if (File(vcRedistPath).existsSync()) {
  //     spinner.success(
  //         'Visual C++ 2015-2022 Redistributable is already donwloaded.');
  //   } else {
  //     spinner.start('Downloading Visual C++ 2015-2022 Redistributable...');
  //     if (argResults['verbose']) {
  //       spinner.stopAndPersist();
  //     }
  //     final download = await dependencyManager.ensureVcredistDownloaded();
  //     if (download == 0) {
  //       spinner.success(
  //           'Downloaded Visual C++ 2015-2022 Redistributable successfully.');
  //     } else {
  //       spinner.fail('Failed to download Visual C++ 2015-2022 Redistributable');
  //     }
  //   }
  // }

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

  /// Builds the Flutter Windows application using the `flutter build` command.
  ///
  /// This method is called by the `run` method and builds the Flutter Windows
  /// application using the `flutter build` command.
  Future<void> _buildFlutterApp() async {
    spinner.start('Building Flutter Windows application...');
    final exitCode = await flutterBuilder.buildApp();
    if (exitCode == 0) {
      spinner.success('Built ${buildMode.buildPath}\\${Config.execName}.');
    } else {
      spinner.fail('Failed to build Flutter application');
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
