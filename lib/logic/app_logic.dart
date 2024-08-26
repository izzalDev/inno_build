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
    await _handleAppId();
    await _checkAndInstallInnoSetup();
    await _buildFlutterApp();
    if (argResults['install-inno'] as bool) {
      await _installInnoSetup();
    }
    await _buildAndCompileInnoSetupScript();
  }

  void _validateFlags() {
    if (argResults['debug'] as bool && argResults['release'] as bool) {
      throw ArgumentError('Error: --release and --debug cannot be used together.');
    }
    if (argResults['verbose'] as bool && argResults['quiet'] as bool) {
      throw ArgumentError('Error: --verbose and --quiet cannot be used together.');
    }
  }

  Future<void> _handleAppId() async {
    if (argResults['app-id'] as bool) {
      spinner.start('Generating new App ID...');
      final newAppId = await appIdService.updateAppId();
      spinner.success('Generated new App ID: $newAppId');
    } else {
      spinner.start('Checking App ID...');
      final appId = await appIdService.ensureAppId();
      spinner.success('Current App ID: $appId');
    }
  }

  Future<void> _checkAndInstallInnoSetup() async {
    spinner.start('Checking Inno Setup...');
    if (File(innoCompilerPath).existsSync()) {
      spinner.success('Inno Setup is already installed.');
    } else {
      await _downloadAndInstallInnoSetup();
    }
  }

  Future<void> _downloadAndInstallInnoSetup() async {
    spinner.start('Downloading Inno Setup...');
    try {
      await dependencyManager.ensureInnoSetupDownloaded();
      spinner.success('Downloaded Inno Setup successfully.');
    } catch (e) {
      spinner.fail('Failed to download Inno Setup');
      stderr.writeln(e);
    }
    spinner.start('Installing Inno Setup...');
    try {
      await innoSetupManager.ensureInnoSetupInstalled();
      spinner.success('Installed Inno Setup successfully.');
    } catch (e) {
      spinner.fail('Failed to install Inno Setup');
      stderr.writeln(e);
    }
  }

  Future<void> _buildFlutterApp() async {
    spinner.start('Building Flutter Windows application...');
    try {
      await flutterBuilder.buildApp();
      spinner.success('Built ${buildMode.buildPath}\\${Config.execName}.');
    } catch (e) {
      spinner.fail('Failed to build Flutter application');
      stderr.writeln(e);
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
      await _downloadAndInstallInnoSetup();
    }
  }

  Future<void> _buildAndCompileInnoSetupScript() async {
    spinner.start('Building Inno Setup script...');
    try {
      final file = await innoSetupManager.buildInnoSetupScript();
      spinner.success('Built ${file.path}.');
    } catch (e) {
      spinner.fail('Failed to build Inno Setup script');
      stderr.writeln(e);
    }

    spinner.start('Compiling Inno Setup script...');
    try {
      await innoSetupManager.compileInnoSetupScript();
      spinner.success('Compiled Inno Setup script successfully.');
    } catch (e) {
      spinner.fail('Failed to compile Inno Setup script');
      stderr.writeln(e);
    }
  }
}
