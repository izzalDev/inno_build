## 0.3.0

### Changed
- Improved logging verbosity for better debugging. [#50](https://github.com/izzalDev/inno_build/pull/50)

## 0.2.0

[Detailed changes](https://github.com/izzalDev/inno_build/compare/b3c81a8332abe5f365a222189d6b8b6fb14dcfc8...df778636f0700aa80fa858df9ebb75ab3a600000)

### Added
- Option for users to choose the install mode (current user/all users).
- Support for including a license file.
- Welcome page with improved images and icons.
- Version information (build number).

### Changed
- `msvcp140.dll`, `vcruntime140.dll`, and `vcruntime140_1.dll` are now included directly in the package.
- Updated to use the app name in the "Run" checkbox instead of the bundle ID.
- Inno Setup compiler embedded directly into the package.

### Fixed
- Issue with Flutter Windows app being built unnecessarily.
- Inability to install vcredist in non-administrative mode.
- Multilingual support for the custom "Launch Program" message.
- API documentation.

## 0.1.2

- Improve missing documentation

## 0.1.1

- Update README.md

## 0.1.0

**Fix :**
- Improved uninstaller functionality in Control Panel.
- Addressed issue where no icon was created in Start Menus.
- Ensured Inno Setup is reinstalled when using options `--install-inno`.
- Fixed issue where Inno Setup was not reinstalled with the `--install-inno` option.

**Change :**
- Specified minimum installer version to 10.0.10240 (Windows 10).
- Changed `outputdir` and now displays a message in the console when finished.
- Always install Inno Setup without the wizard.

## 0.0.2

- Specify platform in pubspec.yaml file

## 0.0.1

- Initial version.
