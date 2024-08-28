import 'package:inno_build/models/file_flag.dart';
import 'package:inno_build/models/icon_flag.dart';
import 'package:inno_build/models/inno.dart';
import 'package:inno_build/models/language.dart';
import 'package:inno_build/models/run_flag.dart';
import 'package:inno_build/models/task_flag.dart';
import 'package:uuid/uuid.dart';

class IssGenerator {
  final StringBuffer _setup = StringBuffer();
  final StringBuffer _languages = StringBuffer();
  final StringBuffer _task = StringBuffer();
  final StringBuffer _files = StringBuffer();
  final StringBuffer _run = StringBuffer();
  final StringBuffer _icons = StringBuffer();

  IssGenerator({
    required String appId,
    required String appName,
    required String appVersion,
    required String defaultDirname,
    required Language defaultLanguages,
  }) {
    _setup.writeln('[Setup]');
    _languages.writeln('[Languages]');
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

  void addFiles(String source, {String? destination, List<FileFlag>? flags}) {
    final destDir = destination ?? Inno.app;
    if (flags != null) {
      _files.writeln(
          'Source: "$source"; DestDir: "$destDir"; Flags: ${flags.join(' ')}');
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

  void addIcons(
    String name,
    String fileName, {
    List<String>? parameters,
    String? workingDir,
    List<String>? hotKey,
    String? comment,
    String? iconFilename,
    String? iconIndex,
    String? appUserModelID,
    Uuid? appUserModelToaseActivatorCLSID,
    List<IconFlag>? flags,
    List<String>? tasks,
  }) {
    String iconsPart = [
      'Name: "$name"',
      'Filename: "$fileName"',
      if (parameters != null && parameters.isNotEmpty)
        'Parameters: "${parameters.join(' ')}"',
      if (workingDir != null) 'WorkingDir: "$workingDir"',
      if (hotKey != null && hotKey.isNotEmpty) 'HotKey: "${hotKey.join('+')}"',
      if (comment != null) 'Comment: "$comment"',
      if (iconFilename != null) 'IconFilename: "$iconFilename"',
      if (iconIndex != null) 'IconIndex: "$iconIndex"',
      if (appUserModelID != null) 'AppUserModelID: "$appUserModelID"',
      if (appUserModelToaseActivatorCLSID != null)
        'AppUserModelToastActivatorCLSID: "$appUserModelToaseActivatorCLSID"',
      if (flags != null && flags.isNotEmpty)
        'Flags: "${flags.join(' ')}"',
      if(tasks != null && tasks.isNotEmpty)'Tasks: ${tasks.join(' ')}'
    ].join('; ');

    if (_icons.isEmpty) {
      _icons.writeln('[ICONS]');
      _icons.writeln(iconsPart);
    } else {
      _icons.writeln(iconsPart);
    }
  }

  void addTasks({
    required String name,
    required String description,
    String? groupDescription,
    List<String>? components,
    List<TaskFlag>? flags,
  }) {
    String tasksPart = [
      'Name: "$name"',
      'Description: "$description"',
      if (groupDescription != null) 'GroupDescription: "$groupDescription"',
      if (components != null && components.isNotEmpty)
        'Components: "${components.join(' ')}"',
      if (flags != null && flags.isNotEmpty) 'Flags: "${flags.join(' ')}"',
    ].join('; ');
    if (_task.isEmpty) {
      _task.writeln('[TASKS]');
      _task.writeln(tasksPart);
    } else {
      _task.writeln(tasksPart);
    }
  }

  StringBuffer build() {
    return StringBuffer()
      ..write(_setup.toString())
      ..write(_languages.toString())
      ..write(_icons)
      ..write(_task.toString())
      ..write(_files.toString())
      ..write(_run.toString());
  }

  @override
  String toString() {
    return build().toString();
  }
}
