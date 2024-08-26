import 'package:inno_build/utils/pubspec_manager.dart';
import 'package:uuid/uuid.dart';

Future<String> generateOrUpdateAppId(PubspecManager pubspecManager) async {
  final appId = Uuid().v4();
  final pubspec = pubspecManager.load();
  pubspec['inno_build'] = {'app_id': appId};
  pubspecManager.save(pubspec);
  return appId;
}
