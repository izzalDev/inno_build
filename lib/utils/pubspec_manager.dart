import 'dart:io';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

/// This class is used to manage the `pubspec.yaml` file.
///
/// It provides functionality to read and write the file.
class PubspecManager {
  /// The path to the `pubspec.yaml` file.
  final String _filepath;

  /// The constructor takes no arguments and sets the `_filepath` to the path to
  /// the `pubspec.yaml` file in the current directory.
  PubspecManager() : _filepath = join(Directory.current.path, 'pubspec.yaml');

  /// Reads the `pubspec.yaml` file and returns the content as a [Map].
  ///
  /// Throws a [FileSystemException] if the file does not exist.
  /// Throws a [FormatException] if the file is not a valid YAML file.
  Map<String, dynamic> load() {
    final file = File(_filepath);
    if (!file.existsSync()) {
      throw FileSystemException('File $_filepath not found');
    }

    try {
      final yamlString = file.readAsStringSync();
      final yamlMap = loadYaml(yamlString) as YamlMap;
      final pubspec = Map<String, dynamic>.from(yamlMap);

      if (pubspec['inno_build'] == null) {
        pubspec['inno_build'] = {};
        save(pubspec);
      }

      return pubspec;
    } catch (e) {
      throw FormatException('Error reading or processing YAML file: $e');
    }
  }

  /// Writes the `pubspec.yaml` file with the given [pubspec].
  ///
  /// Throws a [FileSystemException] if there is an error writing the file.
  void save(Map<String, dynamic> pubspec) {
    final file = File(_filepath);
    final yamlWriter = YamlWriter();
    final updatedYaml = yamlWriter.write(pubspec);

    try {
      file.writeAsStringSync(updatedYaml);
    } catch (e) {
      throw FileSystemException('Error writing YAML file: $e');
    }
  }
}
