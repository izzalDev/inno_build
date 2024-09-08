// Dart imports:
import 'dart:io';

// Package imports:
import 'package:path/path.dart' as p;

/// Enum representing the build mode of the application.
///
/// The build mode is used to determine where the application will be built.
///
/// The two possible values are:
/// - [debug]: The application will be built in debug mode.
/// - [release]: The application will be built in release mode.
enum BuildMode {
  /// Debug build mode.
  ///
  /// The application will be built in debug mode. This means that the
  /// application will be built with debug symbols and will be able to be
  /// debugged.
  debug('Debug'),

  /// Release build mode.
  ///
  /// The application will be built in release mode. This means that the
  /// application will be built without debug symbols and will be
  /// optimized for performance.
  release('Release');

  /// The capitalized name of the build mode.
  ///
  /// This is used to create the directory name where the application will be
  /// built.
  final String capitalize;

  const BuildMode(this.capitalize);

  /// The path where the application will be built.
  ///
  /// This path is computed by joining the current directory with the build mode
  /// name and the sub directory name.
  ///
  /// The sub directory name is either 'runner' or 'installer' depending on the
  /// build mode.
  String _buildPath(String subDirectory) {
    final path = p.join(
      Directory.current.absolute.path,
      'build',
      'windows',
      'x64',
      subDirectory,
      capitalize,
    );
    _ensureDirectoryExists(path);
    return path;
  }

  /// The path where the runner will be built.
  ///
  /// This path is computed by calling [_buildPath] with the sub directory name
  /// 'runner'.
  String get buildPath => _buildPath('runner');

  /// The path where the installer will be built.
  ///
  /// This path is computed by calling [_buildPath] with the sub directory name
  /// 'installer'.
  String get installerPath => _buildPath('installer');

  /// Ensures that the directory exists.
  ///
  /// This method creates the directory if it does not exist.
  void _ensureDirectoryExists(String path) {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }
}
