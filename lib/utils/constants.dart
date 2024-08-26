import 'dart:io';

import 'package:path/path.dart';

final windowsRunnerPath = join(
  Directory.current.absolute.path,
  'build',
  'windows',
  'x64',
  'runner',
);
String tempDir = Directory.systemTemp.path;
String vcRedistUrl = 'https://aka.ms/vs/17/release/vc_redist.x64.exe';
String vcRedistPath = join(tempDir, vcRedistUrl.split('/').last);
String innoCompilerPath = '"%programfiles(x86)%\\Inno Setup 6\\ISCC.exe"';
