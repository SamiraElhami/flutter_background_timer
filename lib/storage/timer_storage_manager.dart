import 'package:background_timer_package/core/shared_pref_keys.dart';
import 'package:background_timer_package/storage/shared_pref_storage.dart';

class TimerStorageManager {
  final SharedPrefsStorage backGroundTimeStampStorage;
  final SharedPrefsStorage timerStorage;

  TimerStorageManager()
    : backGroundTimeStampStorage = SharedPrefsStorage(
        key: SharedPreferenceKeys.backgroundTimeStamp,
      ),
      timerStorage = SharedPrefsStorage(key: SharedPreferenceKeys.timer);

  Future<void> resetAll() async {
    await Future.wait([
      backGroundTimeStampStorage.clear(),
      timerStorage.clear(),
    ]);
  }
}
