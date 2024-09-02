/// Enum representing various icon flags used in application setup.
///
/// Each constant corresponds to a specific icon flag option that can be used
/// in the setup configuration. These flags control various behaviors during
/// the creation of icons.
enum IconFlag {
  /// Sets the "Close on Exit" property of the shortcut.
  /// This flag only has an effect if the shortcut points to an MS-DOS application (.pif extension).
  closeOnExit,

  /// The installer will only try to create the icon if the file specified by the Filename parameter exists.
  createOnlyIfFileExists,

  /// Same as closeOnExit, except it causes Setup to uncheck the "Close on Exit" property.
  dontCloseOnExit,

  /// Prevents the Start menu entry for the new shortcut from receiving a highlight on Windows 7.
  /// Additionally, it prevents the new shortcut from being automatically pinned to the Start screen on Windows 8 (or later).
  /// Ignored on earlier Windows versions.
  excludeFromShowInNewInstall,

  /// Prevents a Start menu entry from being pinnable to Taskbar or the Start Menu on Windows 7 (or later).
  /// This also makes the entry ineligible for inclusion in the Start menu's Most Frequently Used (MFU) list.
  /// Ignored on earlier Windows versions.
  preventPinning,

  /// Sets the "Run" setting of the icon to "Maximized" so that the program will be initially maximized when it is started.
  runMaximized,

  /// Sets the "Run" setting of the icon to "Minimized" so that the program will be initially minimized when it is started.
  runMinimized,

  /// Instructs the uninstaller not to delete the icon.
  uninsNeverUninstall,

  /// When this flag is set, specify just a filename (no path) in the Filename parameter.
  /// Setup will retrieve the pathname from the "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" registry key and prepend it to the filename automatically.
  useAppPaths;

  @override
  String toString() {
    return name.toLowerCase();
  }
}
