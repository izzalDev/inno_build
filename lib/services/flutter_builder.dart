// lib/services/flutter_builder.dart

// Dart imports:
import 'dart:io';

// Project imports:
import 'package:inno_build/models/build_mode.dart';

/// Class that builds a Flutter application.
///
/// This class abstracts the process of building a Flutter application
/// using the `flutter build` command. The application is built in the
/// mode specified by [buildMode].
///
/// The [verbose] parameter allows to control the verbosity of the
/// command. If `true`, the `flutter build` command will be executed with
/// the `--verbose` flag and the output will be printed to the console.
/// If `false`, the command will be executed with the `--quiet` flag and
/// the output will be silent.
class FlutterBuilder {
  /// Whether the `flutter build` command should be executed with the
  /// `--verbose` flag.
  ///
  /// If `true`, the output will be printed to the console. If `false`, the
  /// output will be silent.
  final bool verbose;

  /// The build mode to use when building the Flutter application.
  ///
  /// The build mode determines where the application will be built.
  /// The possible values are:
  /// - [BuildMode.debug]: The application will be built in debug mode.
  /// - [BuildMode.release]: The application will be built in release mode.
  final BuildMode buildMode;

  /// Creates a new instance of [FlutterBuilder].
  ///
  /// The [verbose] parameter allows to control the verbosity of the
  /// command. If `true`, the `flutter build` command will be executed with
  /// the `--verbose` flag and the output will be printed to the console.
  /// If `false`, the command will be executed with the `--quiet` flag and
  /// the output will be silent.
  FlutterBuilder(this.buildMode, {this.verbose = false});

  /// Builds the Flutter application.
  ///
  /// This method executes the `flutter build` command with the options
  /// specified by [buildMode] and [verbose].
  /// The method returns the exit code of the `flutter build` command.
  Future<int> buildApp() async {
    final mode = buildMode.name;
    List<String> args = ['build', 'windows', '--$mode'];
    if (verbose) args.add('--verbose');
    final process = await Process.start(
      "flutter",
      args,
      runInShell: true,
      mode: verbose ? ProcessStartMode.inheritStdio : ProcessStartMode.normal,
    );
    return process.exitCode;
  }
}
