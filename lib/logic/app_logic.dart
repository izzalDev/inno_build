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

class AppLogic {
  final ArgResults argResults;
  final PubspecManager pubspecManager;
  final AppIdService appIdService;
  final DependencyManager dependencyManager;
  final FlutterBuilder flutterBuilder;
  final InnoSetupManager innoSetupManager;
  final CliSpin spinner;
  final BuildMode buildMode;

  AppLogic({
    required this.argResults,
    required this.pubspecManager,
    required this.appIdService,
    required this.dependencyManager,
    required this.flutterBuilder,
    required this.innoSetupManager,
    required this.spinner,
    required this.buildMode,
  });

  Future<void> run() async {
    _validateFlags();
    if (argResults['install-inno']) {
      await _checkAndInstallInnoSetup();
      exit(0);
    }
    await _handleAppId();
    await _checkAndInstallInnoSetup();
    await _buildFlutterApp();
    await _buildInnoSetupScript();
    await _compileInnoSetupScript();
  }

  void _validateFlags() {
    if (argResults['debug'] && argResults['release']) {
      throw ArgumentError(
          'Error: --release and --debug cannot be used together.');
    }
    if (argResults['verbose'] && argResults['quiet']) {
      throw ArgumentError(
          'Error: --verbose and --quiet cannot be used together.');
    }
  }

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

  Future<void> _checkAndInstallInnoSetup() async {
    spinner.start('Checking Inno Setup...');
    if (File(innoCompilerPath).existsSync()) {
      spinner.success('Inno Setup is already installed.');
    } else {
      await _installInnoSetup();
    }
  }

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

  Future<void> _buildFlutterApp() async {
    spinner.start('Building Flutter Windows application...');
    if (argResults['verbose']) {
      spinner.stopAndPersist();
    }
    final exitCode = await flutterBuilder.buildApp();
    if (exitCode == 0) {
      spinner.success('Built ${buildMode.buildPath}\\${Config.execName}.');
    } else {
      spinner.fail('Failed to build Flutter application');
    }
  }

  Future<void> _installInnoSetup() async {
    if (File(innoSetupInstallerPath).existsSync()) {
      spinner.start('Installing Inno Setup...');
      try {
        await innoSetupManager.ensureInnoSetupInstalled();
        spinner.success('Installed Inno Setup successfully.');
      } catch (e) {
        spinner.fail('Failed to install Inno Setup');
        stderr.writeln(e);
      }
    } else {
      await _downloadInnoSetup();
      final install = await innoSetupManager.ensureInnoSetupInstalled();
      if (install == 0) {
        spinner.success('Installed Inno Setup successfully.');
      } else {
        spinner.fail('Failed to install Inno Setup');
      }
    }
  }

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

  Future<void> _compileInnoSetupScript() async {
    spinner.start('Compiling Inno Setup script...');
    if (argResults['verbose']) {
      spinner.stopAndPersist();
    }
    final exitCode = await innoSetupManager.compileInnoSetupScript();
    if (exitCode == 0) {
      spinner.success('Compiled Inno Setup script successfully.');
    } else {
      spinner.fail('Failed to compile Inno Setup script');
    }
  }
}
