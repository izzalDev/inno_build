/// Enum representing various run flags used in application setup.
///
/// Each constant corresponds to a specific run flag option that can be used
/// in the setup configuration. These flags control various behaviors during
/// the execution of setup or uninstall processes.
enum RunFlag {
  /// Causes the {sys} constant to map to the 32-bit System directory.
  /// Default behavior in 32-bit install mode.
  /// Cannot be combined with the shellexec flag.
  bit32('32bit'),

  /// Causes the {sys} constant to map to the 64-bit System directory.
  /// Default behavior in 64-bit install mode.
  /// Can only be used on 64-bit Windows.
  /// Cannot be combined with the shellexec flag.
  bit64('64bit'),

  /// If specified, command line parameters for the program will not be included in the log file.
  dontLogParameters('dontlogparameters'),

  /// If specified, the wizard will be hidden while the program is running.
  hideWizard('hidewizard'),

  /// If specified, the output of the program will be included in the log file.
  /// Cannot be combined with nowait, runasoriginaluser, shellexec, and waituntilidle flags.
  logOutput('logoutput'),

  /// If specified, the process will not wait to finish executing before proceeding to the next entry.
  /// Cannot be combined with waituntilidle or waituntilterminated.
  noWait('nowait'),

  /// Valid only in a [Run] section. Creates a checkbox on the Setup Completed wizard page for user selection.
  /// If the system restarts, the checkbox will not be displayed.
  postInstall('postinstall'),

  /// If specified, the spawned process will inherit Setup/Uninstall's user credentials.
  /// Default behavior when the postinstall flag is not used.
  /// Cannot be combined with runasoriginaluser flag.
  runAsCurrentUser('runascurrentuser'),

  /// Valid only in a [Run] section. Executes the process with the original user's non-elevated credentials.
  /// Ineffective if Setup is run as administrator or from an elevated process.
  /// Cannot be combined with runascurrentuser flag.
  runAsOriginalUser('runasoriginaluser'),

  /// If specified, launches the program in a hidden window.
  /// Not recommended for programs that may prompt for user input.
  runHidden('runhidden'),

  /// If specified, launches the program or document in a maximized window.
  runMaximized('runmaximized'),

  /// If specified, launches the program or document in a minimized window.
  runMinimized('runminimized'),

  /// Required if Filename is not a directly executable file.
  /// Opens Filename with the application associated with the file type on the user's system.
  /// Cannot be combined with nowait, waituntilidle, or waituntilterminated flags.
  shellExec('shellexec'),

  /// If specified, no error message will be displayed if Filename doesn't exist.
  skipIfDoesNotExist('skipifdoesntexist'),

  /// Valid only in a [Run] section. Skips this entry if Setup is not running silently.
  skipIfNotSilent('skipifnotsilent'),

  /// Valid only in a [Run] section. Skips this entry if Setup is running silently.
  skipIfSilent('skipifsilent'),

  /// Valid only in a [Run] section. Initially unchecks the checkbox on the Setup Completed wizard page.
  /// Ignored if postinstall flag is not specified.
  unchecked('unchecked'),

  /// If specified, waits until the process is waiting for user input with no input pending.
  /// Cannot be combined with nowait or waituntilterminated.
  waitUntilIdle('waituntilidle'),

  /// If specified, waits until the process has completely terminated.
  /// Default behavior unless using shellexec flag, in which case it is required if you want to wait.
  /// Cannot be combined with nowait or waituntilidle.
  waitUntilTerminated('waituntilterminated');

  final String flag;

  const RunFlag(this.flag);

  @override
  String toString() {
    return flag;
  }
}
