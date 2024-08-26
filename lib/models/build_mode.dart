import 'dart:io';
import 'package:path/path.dart' as p;

enum BuildMode {
  debug('Debug'),
  release('Release');

  final String capitalize;
  
  const BuildMode(this.capitalize);

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

  String get buildPath => _buildPath('runner');

  String get installerPath => _buildPath('installer');

  void _ensureDirectoryExists(String path) {
    final directory = Directory(path);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
  }
}
