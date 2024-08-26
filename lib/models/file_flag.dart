/// Enum defining various additional options for file settings.
///
/// These options are used in parameters to determine how files should
/// be treated during the installation process. Options include settings
/// for 32-bit or 64-bit files, access permissions, and behavior when
/// files already exist.
enum FileFlag {
  /// Treat the file as 32-bit.
  bit32,

  /// Treat the file as 64-bit.
  bit64,

  /// Allow unsafe files without automatic checks by the compiler.
  allowUnsafeFiles,

  /// Compare timestamps when the file already exists.
  compareTimestamp,

  /// Prompt the user for confirmation before overwriting an existing file.
  confirmOverwrite,

  /// Create empty subdirectories during the installation process.
  createAllSubdirs,

  /// Delete the file after the installation is complete.
  deleteAfterInstall,

  /// Do not copy the file to the user’s system but include it statically in the installation.
  dontCopy,

  /// Do not verify the checksum of the file after extraction.
  dontVerifyChecksum,

  /// Use files from distribution media or the user’s system instead of compiling them statically.
  external,

  /// Mark the file as non-TrueType font when using the FontInstall parameter.
  fontIsntTrueType,

  /// Install the file into the .NET Global Assembly Cache.
  gacInstall,

  /// Ignore version information and overwrite existing files without comparing versions.
  ignoreVersion,

  /// Mark the file as a "README" that will be displayed after installation.
  isReadMe,

  /// Do not compress the file.
  noCompression,

  /// Do not encrypt the file even if encryption is enabled in the [Setup] settings.
  noEncryption,

  /// Do not display error messages if registration fails with regserver or regtypelib flags.
  noRegError,

  /// Only install the file if a file with the same name already exists on the user's system.
  onlyIfDestFileExists,

  /// Only install the file if a file with the same name does not exist on the user's system.
  onlyIfDoesntExist,

  /// Always overwrite read-only files.
  overwriteReadOnly,

  /// Prompt the user whether to replace older files if an existing file is found.
  promptIfOlder,

  /// Search for filename/wildcard in subdirectories under the source directory.
  recurseSubdirs,

  /// Register DLL/OCX files.
  regServer,

  /// Register type libraries (.tlb).
  regTypeLib,

  /// Replace existing files if their versions are the same.
  replaceSameVersion,

  /// Register the file to be replaced upon system restart if it is in use.
  restartReplace,

  /// Enable NTFS compression on the file.
  setNTFSCompression,

  /// Mark the file as a shared file that is only deleted if not used by other applications.
  sharedFile,

  /// Digitally sign the source file before saving it.
  sign,

  /// Check the digital signature of the source file before saving it.
  signCheck,

  /// Digitally sign the source file only if it is not already signed.
  signOnce,

  /// Skip the entry if the source file does not exist without showing an error message.
  skipIfSourceDoesntExist,

  /// Complete the existing compression stream and start a new one before compressing the file.
  solidBreak,

  /// Compress files found by extension order before path name order.
  sortFilesByExtension,

  /// Compress files found by name order before path name order.
  sortFilesByName,

  /// Set the installed file's timestamp according to the TouchDate and TouchTime settings.
  touch,

  /// Automatically delete the file if its reference count reaches zero during uninstall.
  uninsNoSharedFilePrompt,

  /// Remove the read-only attribute from the file before deleting it during uninstall.
  uninsRemoveReadOnly,

  /// Add the file to be deleted on system restart after uninstall.
  uninsRestartDelete,

  /// Never uninstall the file during uninstall.
  uninsNeverUninstall,

  /// Disable NTFS compression on the file.
  unsetNTFSCompression;

  /// Returns the custom string representation of the enum value.
  @override
  String toString() {
    // Returns the name of the enum value as a string.
    return name.toLowerCase();
  }
}
