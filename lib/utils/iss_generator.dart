import 'package:inno_build/models/file_flag.dart';
import 'package:inno_build/models/inno.dart';
import 'package:inno_build/models/language.dart';
import 'package:inno_build/models/run_flag.dart';

class IssGenerator {
  final StringBuffer _setup = StringBuffer();
  final StringBuffer _languages = StringBuffer();
  final StringBuffer _task = StringBuffer();
  final StringBuffer _files = StringBuffer();
  final StringBuffer _run = StringBuffer();

  IssGenerator({
    required String appId,
    required String appName,
    required String appVersion,
    required String defaultDirname,
    required Language defaultLanguages,
  }) {
    _setup.writeln('[Setup]');
    _languages.writeln('[Languages]');
    _task.writeln('[Task]');
    _files.writeln('[Files]');
    _run.writeln('[Run]');
    addSetup('AppId', appId);
    addSetup('AppName', appName);
    addSetup('AppVersion', appVersion);
    addSetup('DefaultDirName', defaultDirname);
    addSetup('ArchitecturesAllowed', 'x64compatible');
    addSetup('ArchitecturesInstallIn64BitMode', 'x64compatible');
    addSetup('Compression', 'lzma2/max');
    addSetup('SolidCompression', 'yes');
    addSetup('WizardStyle', 'modern');
    addLanguages(defaultLanguages);
  }

  void addSetup(String key, String value) {
    _setup.writeln('$key=$value');
  }

  void addLanguages(Language language) {
    _languages.writeln(
        'Name: "${language.name}"; MessagesFile: "compiler:${language.file}"');
  }

  // void addTask() {
  //   _task.writeln();
  // }

  void addFiles(String source, {String? destination, List<FileFlag>? flags}) {
    final destDir = destination ?? Inno.app;
    if (flags != null) {
      _files.writeln(
          'Source: "$source"; DestDir: "$destDir"; Flags: ${flags.join()}');
    } else {
      _files.writeln('Source: "$source"; DestDir: "$destDir"');
    }
  }

  void addRun(
    String fileName, {
    String? parameters,
    List<RunFlag>? flags,
    String? message,
  }) {
    String runPart = [
      'Filename: "$fileName"',
      if (parameters != null) 'Parameters: "$parameters"',
      if (flags != null && flags.isNotEmpty) 'Flags: ${flags.join(' ')}',
      if (message != null) 'StatusMsg: $message',
    ].join('; ');

    _run.writeln(runPart);
  }

  StringBuffer build() {
    return StringBuffer()
      ..write(_setup.toString())
      ..write(_languages.toString())
      ..write(_task.toString())
      ..write(_files.toString())
      ..write(_run.toString());
  }

  @override
  String toString() {
    return build().toString();
  }
}
