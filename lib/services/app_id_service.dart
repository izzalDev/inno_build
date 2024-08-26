// lib/services/app_id_service.dart

import 'package:inno_build/utils/pubspec_manager.dart';
import 'package:uuid/uuid.dart';

class AppIdService {
  final PubspecManager _pubspecManager;

  AppIdService(this._pubspecManager);

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

  Future<String> updateAppId() async {
    final appId = Uuid().v4();
    final pubspec = _pubspecManager.load();

    pubspec['inno_build']['app_id'] = appId;
    _pubspecManager.save(pubspec);

    return appId;
  }
}
