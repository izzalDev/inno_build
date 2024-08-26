import 'dart:io';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

class PubspecManager {
  final String _filepath;

  PubspecManager() : _filepath = join(Directory.current.path, 'pubspec.yaml');

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
