// Package imports:
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:inno_build/models/file_flag.dart';
import 'package:inno_build/models/icon_flag.dart';
import 'package:inno_build/models/inno.dart';
import 'package:inno_build/models/language.dart';
import 'package:inno_build/models/run_flag.dart';
import 'package:inno_build/models/task_flag.dart';

/// Generates an Inno Setup script file.
class IssGenerator {
  final StringBuffer _setup = StringBuffer();
  final StringBuffer _languages = StringBuffer();
  final StringBuffer _task = StringBuffer();
  final StringBuffer _files = StringBuffer();
  final StringBuffer _run = StringBuffer();
  final StringBuffer _icons = StringBuffer();

  /// Creates a new [IssGenerator] instance.
  ///
  /// [appId], [appName], [appVersion], [defaultDirname], and [defaultLanguages]
  /// are required.
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
    addSetup(key: 'AppId', value: appId);
    addSetup(key: 'AppName', value: appName);
    addSetup(key: 'AppVersion', value: appVersion);
    addSetup(key: 'DefaultDirName', value: defaultDirname);
    addSetup(key: 'ArchitecturesAllowed', value: 'x64compatible');
    addSetup(key: 'ArchitecturesInstallIn64BitMode', value: 'x64compatible');
    addSetup(key: 'Compression', value: 'lzma2/max');
    addSetup(key: 'SolidCompression', value: 'yes');
    addSetup(key: 'WizardStyle', value: 'modern');
    addLanguages(defaultLanguages);
  }

  /// Adds a setup entry to the Inno Setup script.
  ///
  /// [key] and [value] are required.
  void addSetup({required String key, required String value}) {
    _setup.writeln('$key=$value');
  }

  /// Adds a language entry to the Inno Setup script.
  ///
  /// [language] is required.
  void addLanguages(Language language) {
    _languages.writeln(
        'Name: "${language.name}"; MessagesFile: "compiler:${language.file}"');
  }

  /// Adds a [File] entry to the Inno Setup script.
  ///
  /// [source] is required. [destination] is optional and defaults to [Inno.app].
  /// [flags] is optional.
  void addFiles({
    required String source,
    String? destination,
    List<FileFlag>? flags,
  }) {
    final destDir = destination ?? Inno.app;
    if (flags != null) {
      _files.writeln(
          'Source: "$source"; DestDir: "$destDir"; Flags: ${flags.join(' ')}');
    } else {
      _files.writeln('Source: "$source"; DestDir: "$destDir"');
    }
  }

  /// Adds a [Run] entry to the Inno Setup script.
  ///
  /// [fileName] is required. [parameters], [flags], and [message] are optional.
  void addRun({
    required String fileName,
    String? parameters,
    List<RunFlag>? flags,
    String? message,
    String? description,
  }) {
    String runPart = [
      'Filename: "$fileName"',
      if (parameters != null) 'Parameters: "$parameters"',
      if (flags != null && flags.isNotEmpty) 'Flags: ${flags.join(' ')}',
      if (message != null) 'StatusMsg: $message',
      if (description != null) 'Description: $description'
    ].join('; ');

    _run.writeln(runPart);
  }

  /// Adds an [Icon] entry to the Inno Setup script.
  ///
  /// [name], [fileName], and [parameters] are required. [workingDir], [hotKey],
  /// [comment], [iconFilename], [iconIndex], [appUserModelID],
  /// [appUserModelToaseActivatorCLSID], and [flags] are optional. [tasks] is
  /// optional.
  void addIcons({
    required String name,
    required String fileName,
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
      if (flags != null && flags.isNotEmpty) 'Flags: "${flags.join(' ')}"',
      if (tasks != null && tasks.isNotEmpty) 'Tasks: ${tasks.join(' ')}'
    ].join('; ');

    if (_icons.isEmpty) {
      _icons.writeln('[ICONS]');
      _icons.writeln(iconsPart);
    } else {
      _icons.writeln(iconsPart);
    }
  }

  /// Adds a [Task] entry to the Inno Setup script.
  ///
  /// [name] and [description] are required. [groupDescription] is optional.
  /// [components] and [flags] are optional.
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

  /// Builds the Inno Setup script.
  ///
  /// Returns a [StringBuffer] containing the Inno Setup script.
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
