import 'dart:io';
import 'package:cli_spin/cli_spin.dart';
import 'package:inno_build/models/build_mode.dart';
import 'package:inno_build/models/file_flag.dart';
import 'package:inno_build/models/inno.dart';
import 'package:inno_build/logic/app_logic.dart';

void main(List<String> arguments) async {
  final spin = CliSpin();
  print(BuildMode.debug.name);

  try {
    spin.start('Starting application...');
    // Menyiapkan layanan ConfigService dan PubspecService
    // final configService = ConfigService('config.yaml');
    // final pubspecService = PubspecService('pubspec.yaml', configService);

    // Menetapkan konfigurasi jika diperlukan
    // await pubspecService.configureApp('version', '1.1.0');
    // await pubspecService.applyConfigurations();

    // // Logika aplikasi lainnya
    // final appId = arguments.isNotEmpty ? arguments[0] : null;
    // final isRelease = !arguments.contains('--debug');
    // final isDebug = arguments.contains('--debug');

    // await runAppLogic(appId: appId, isRelease: isRelease, isDebug: isDebug);

    // spin.stop(success: 'Application completed successfully.');
  } catch (e) {
    // spin.stop(success: 'An error occurred: $e');
  }
}
