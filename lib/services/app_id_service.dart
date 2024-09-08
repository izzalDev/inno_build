// lib/services/app_id_service.dart

// Package imports:
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:inno_build/utils/pubspec_manager.dart';

/// Class that handles the app id
///
/// The app id is a unique identifier that is used to identify the app in the
/// Windows registry. It is automatically generated when the user runs `inno
/// build` for the first time with the `--app-id` flag.
///
/// The app id is stored in the `pubspec.yaml` file under the key
/// `inno_build.app_id`.
class AppIdService {
  /// The pubspec manager used to read and write the `pubspec.yaml` file.
  final PubspecManager _pubspecManager;

  /// Creates a new instance of [AppIdService].
  AppIdService(this._pubspecManager);

  /// Ensures that the app id exists in the `pubspec.yaml` file.
  ///
  /// If the app id does not exist, it is generated and saved to the
  /// `pubspec.yaml` file. If it exists, the existing value is returned.
  ///
  /// Returns the app id.
  Future<String> ensureAppId() async {
    final appId = Uuid().v4();
    final pubspec = _pubspecManager.load();

    if (pubspec['inno_build']['app_id'] == null) {
      pubspec['inno_build']['app_id'] = appId;
      _pubspecManager.save(pubspec);
      return appId;
    } else {
      return pubspec['inno_build']['app_id'] as String;
    }
  }

  /// Updates the app id in the `pubspec.yaml` file.
  ///
  /// Generates a new app id and saves it to the `pubspec.yaml` file.
  ///
  /// Returns the new app id.
  Future<String> updateAppId() async {
    final appId = Uuid().v4();
    final pubspec = _pubspecManager.load();

    pubspec['inno_build']['app_id'] = appId;
    _pubspecManager.save(pubspec);

    return appId;
  }
}
