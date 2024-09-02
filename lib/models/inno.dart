/// Enum representing common directory constants used in an application setup.
///
/// Each constant is a placeholder for a specific system directory or path.
enum Inno {
  /// Application directory.
  ///
  /// Example: If the user selects "C:\MYPROG" as the application directory,
  /// {app}\MYPROG.EXE will be translated to "C:\MYPROG\MYPROG.EXE".
  app('{app}'),

  /// Windows directory.
  ///
  /// Example: If the system's Windows directory is "C:\WINDOWS",
  /// {win}\MYPROG.INI will be translated to "C:\WINDOWS\MYPROG.INI".
  win('{win}'),

  /// System32 directory.
  ///
  /// Example: If the system's Windows System directory is "C:\WINDOWS\SYSTEM",
  /// {sys}\CTL3D32.DLL will be translated to "C:\WINDOWS\SYSTEM\CTL3D32.DLL".
  sys('{sys}'),

  /// 64-bit system directory.
  ///
  /// On 64-bit Windows, this represents the 64-bit system directory. On 32-bit
  /// Windows, it maps to the same directory as {sys}.
  /// Example: On a 64-bit system, {sysnative}\SYSTEM32.DLL will be translated to "C:\WINDOWS\SYSTEM32\SYSTEM32.DLL".
  sysnative('{sysnative}'),

  /// SysWOW64 directory.
  ///
  /// On 64-bit Windows, this represents the directory containing 32-bit system files.
  /// On 32-bit Windows, it maps to the same directory as {sys}.
  /// Example: On a 64-bit system, {syswow64}\SOMEFILE.DLL will be translated to "C:\WINDOWS\SysWOW64\SOMEFILE.DLL".
  syswow64('{syswow64}'),

  /// Source directory where setup files are located.
  ///
  /// Example: If the setup files are located in "S:\", {src}\MYPROG.EXE will be translated to "S:\MYPROG.EXE".
  src('{src}'),

  /// System drive where Windows is installed.
  ///
  /// Example: If Windows is installed on drive "C:", {sd}\MYFILE.DLL will be translated to "C:\MYFILE.DLL".
  sd('{sd}'),

  /// Program Files directory.
  ///
  /// Example: If the system's Program Files directory is "C:\Program Files",
  /// {commonpf}\MYAPP.EXE will be translated to "C:\Program Files\MYAPP.EXE".
  commonpf('{commonpf}'),

  /// 32-bit Program Files directory.
  ///
  /// On 64-bit Windows, this refers to "C:\Program Files (x86)".
  /// Example: On a 64-bit system, {commonpf32}\MYAPP.EXE will be translated to "C:\Program Files (x86)\MYAPP.EXE".
  commonpf32('{commonpf32}'),

  /// 64-bit Program Files directory.
  ///
  /// Example: On a 64-bit Windows, {commonpf64}\MYAPP.EXE will be translated to "C:\Program Files\MYAPP.EXE".
  commonpf64('{commonpf64}'),

  /// Common Files directory.
  ///
  /// Example: If the system's Common Files directory is "C:\Program Files\Common Files",
  /// {commoncf}\MYFILE.DLL will be translated to "C:\Program Files\Common Files\MYFILE.DLL".
  commoncf('{commoncf}'),

  /// 32-bit Common Files directory.
  ///
  /// On 64-bit Windows, this refers to "C:\Program Files (x86)\Common Files".
  /// Example: On a 64-bit system, {commoncf32}\MYFILE.DLL will be translated to "C:\Program Files (x86)\Common Files\MYFILE.DLL".
  commoncf32('{commoncf32}'),

  /// 64-bit Common Files directory.
  ///
  /// Example: On a 64-bit Windows, {commoncf64}\MYFILE.DLL will be translated to "C:\Program Files\Common Files\MYFILE.DLL".
  commoncf64('{commoncf64}'),

  /// Temporary directory used by Setup or Uninstall.
  ///
  /// Example: During setup, {tmp}\TEMPFILE.DLL will be translated to "C:\WINDOWS\TEMP\IS-xxxxx.tmp\TEMPFILE.DLL".
  tmp('{tmp}'),

  /// Fonts directory.
  ///
  /// Example: The fonts directory is typically "C:\WINDOWS\Fonts".
  commonfonts('{commonfonts}'),

  /// DAO directory.
  ///
  /// Example: {dao}\MYFILE.DLL will be translated to "C:\Program Files\Common Files\Microsoft Shared\DAO\MYFILE.DLL".
  dao('{dao}'),

  /// .NET Framework version 1.1 install root directory.
  ///
  /// Example: {dotnet11}\MYFILE.DLL will be translated to "C:\Windows\Microsoft.NET\Framework\v1.1.4322\MYFILE.DLL".
  dotnet11('{dotnet11}'),

  /// .NET Framework version 2.0-3.5 install root directory.
  ///
  /// Example: {dotnet20}\MYFILE.DLL will be translated to "C:\Windows\Microsoft.NET\Framework\v2.0.50727\MYFILE.DLL".
  dotnet20('{dotnet20}'),

  /// 32-bit .NET Framework version 2.0-3.5 install root directory.
  ///
  /// Example: {dotnet2032}\MYFILE.DLL will be translated to "C:\Windows\Microsoft.NET\Framework\v2.0.50727\MYFILE.DLL".
  dotnet2032('{dotnet2032}'),

  /// 64-bit .NET Framework version 2.0-3.5 install root directory.
  ///
  /// Example: {dotnet2064}\MYFILE.DLL will be translated to "C:\Windows\Microsoft.NET\Framework64\v2.0.50727\MYFILE.DLL".
  dotnet2064('{dotnet2064}'),

  /// .NET Framework version 4.0 and later install root directory.
  ///
  /// Example: {dotnet40}\MYFILE.DLL will be translated to "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MYFILE.DLL".
  dotnet40('{dotnet40}'),

  /// 32-bit .NET Framework version 4.0 and later install root directory.
  ///
  /// Example: {dotnet4032}\MYFILE.DLL will be translated to "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MYFILE.DLL".
  dotnet4032('{dotnet4032}'),

  /// 64-bit .NET Framework version 4.0 and later install root directory.
  ///
  /// Example: {dotnet4064}\MYFILE.DLL will be translated to "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MYFILE.DLL".
  dotnet4064('{dotnet4064}'),

  /// Auto application data directory.
  ///
  /// Example: Depending on the installation mode, {autoappdata}\MYFILE.DLL will be translated to either
  /// "C:\ProgramData\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Local\MYFILE.DLL" (for non-administrative).
  autoappdata('{autoappdata}'),

  /// Auto Common Files directory.
  ///
  /// Example: Depending on the installation mode, {autocf}\MYFILE.DLL will be translated to either
  /// "C:\Program Files\Common Files\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Local\MYFILE.DLL" (for non-administrative).
  autocf('{autocf}'),

  /// Auto 32-bit Common Files directory.
  ///
  /// Example: Depending on the installation mode, {autocf32}\MYFILE.DLL will be translated to either
  /// "C:\Program Files (x86)\Common Files\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Local\MYFILE.DLL" (for non-administrative).
  autocf32('{autocf32}'),

  /// Auto 64-bit Common Files directory.
  ///
  /// Example: Depending on the installation mode, {autocf64}\MYFILE.DLL will be translated to either
  /// "C:\Program Files\Common Files\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Local\MYFILE.DLL" (for non-administrative).
  autocf64('{autocf64}'),

  /// Auto Desktop directory.
  ///
  /// Example: Depending on the installation mode, {autodesktop}\MYFILE.DLL will be translated to either
  /// "C:\Users\<User>\Desktop\MYFILE.DLL" (for non-administrative) or "C:\ProgramData\Desktop\MYFILE.DLL" (for administrative).
  autodesktop('{autodesktop}'),

  /// Auto Documents directory.
  ///
  /// Example: Depending on the installation mode, {autodocs}\MYFILE.DLL will be translated to either
  /// "C:\Users\<User>\Documents\MYFILE.DLL" (for non-administrative) or "C:\ProgramData\Documents\MYFILE.DLL" (for administrative).
  autodocs('{autodocs}'),

  /// Auto Fonts directory.
  ///
  /// Example: Depending on the installation mode, {autofonts}\MYFILE.DLL will be translated to either
  /// "C:\Windows\Fonts\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Local\Fonts\MYFILE.DLL" (for non-administrative).
  autofonts('{autofonts}'),

  /// Auto Program Files directory.
  ///
  /// Example: Depending on the installation mode, {autopf}\MYFILE.DLL will be translated to either
  /// "C:\Program Files\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Local\Program Files\MYFILE.DLL" (for non-administrative).
  autopf('{autopf}'),

  /// Auto 32-bit Program Files directory.
  ///
  /// Example: Depending on the installation mode, {autopf32}\MYFILE.DLL will be translated to either
  /// "C:\Program Files (x86)\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Local\Program Files (x86)\MYFILE.DLL" (for non-administrative).
  autopf32('{autopf32}'),

  /// Auto 64-bit Program Files directory.
  ///
  /// Example: Depending on the installation mode, {autopf64}\MYFILE.DLL will be translated to either
  /// "C:\Program Files\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Local\Program Files\MYFILE.DLL" (for non-administrative).
  autopf64('{autopf64}'),

  /// Auto Programs directory.
  ///
  /// Example: Depending on the installation mode, {autoprograms}\MYFILE.DLL will be translated to either
  /// "C:\ProgramData\Programs\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Local\Programs\MYFILE.DLL" (for non-administrative).
  autoprograms('{autoprograms}'),

  /// Auto Start Menu directory.
  ///
  /// Example: Depending on the installation mode, {autostartmenu}\MYFILE.DLL will be translated to either
  /// "C:\ProgramData\Start Menu\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Roaming\Microsoft\Windows\Start Menu\MYFILE.DLL" (for non-administrative).
  autostartmenu('{autostartmenu}'),

  /// Auto Startup directory.
  ///
  /// Example: Depending on the installation mode, {autostartup}\MYFILE.DLL will be translated to either
  /// "C:\ProgramData\Startup\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\MYFILE.DLL" (for non-administrative).
  autostartup('{autostartup}'),

  /// Auto Templates directory.
  ///
  /// Example: Depending on the installation mode, {autotemplates}\MYFILE.DLL will be translated to either
  /// "C:\ProgramData\Templates\MYFILE.DLL" (for administrative) or "C:\Users\<User>\AppData\Roaming\Microsoft\Templates\MYFILE.DLL" (for non-administrative).
  autotemplates('{autotemplates}');

  /// The Inno Setup directory constant.
  ///
  /// This is the string that Inno Setup will replace with the actual directory
  /// path when it is encountered in a [Files] section entry.
  ///
  /// Example: If you specify `{app}` in the `DestDir` parameter of a [Files]
  /// section entry, Inno Setup will replace it with the actual installation
  /// directory path.
  final String value;

  const Inno(this.value);

  @override
  String toString() {
    return value;
  }
}
