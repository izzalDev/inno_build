// Dart imports:
import 'dart:io';

// Project imports:
import 'package:inno_build/models/build_mode.dart';

/// Class that builds a Flutter application.
///
/// This class abstracts the process of building a Flutter application
/// using the `flutter build` command. It dynamically constructs the command
/// based on the provided build mode and additional Flutter arguments.
class FlutterBuilder {
  /// The build mode to use when building the Flutter application.
  final BuildMode buildMode;

  /// A map of additional arguments to pass to the 'flutter build' command.
  /// Keys are the argument names (e.g., 'obfuscate', 'split-debug-info')
  /// and values are the argument values.
  /// For flags, the value should be `true`. For options with values,
  /// it should be the string value. For multi-options, it can be a list.
  final Map<String, dynamic> flutterBuildArgs;

  /// Creates a new instance of [FlutterBuilder].
  ///
  /// [buildMode] determines the build configuration (e.g., debug, release).
  /// [flutterBuildArgs] contains all additional parameters to be passed
  /// to the flutter build command.
  FlutterBuilder({
    required this.buildMode,
    this.flutterBuildArgs = const {},
  });

  /// Builds the Flutter application.
  ///
  /// This method executes the `flutter build` command with the options
  /// specified by [buildMode] and [flutterBuildArgs].
  /// The method returns the exit code of the `flutter build` command.
  Future<int> buildApp() async {
    final mode = buildMode.name;
    final List<String> args = ['/c', 'flutter', 'build', 'windows', '--$mode'];

    // Dynamically add arguments from the map
    flutterBuildArgs.forEach((key, value) {
      // For flags like --obfuscate or --verbose where value is true
      if (value is bool && value == true) {
        args.add('--$key');
      }
      // For options with values like --split-debug-info=...
      else if (value is String && value.isNotEmpty) {
        args.add('--$key=$value');
      }
      // For list values like --dart-define=KEY=VALUE
      else if (value is List) {
        for (final item in value) {
          if (item is String) {
            args.add('--$key=$item');
          }
        }
      }
    });

    final bool isVerbose = flutterBuildArgs['verbose'] == true;

    // For debugging purposes, print the command that will be executed.
    if (isVerbose) {
      print('Executing command: cmd.exe ${args.join(' ')}');
    }

    final process = await Process.start(
      'cmd',
      args,
      mode: isVerbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );
    return await process.exitCode;
  }
}