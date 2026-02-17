import 'package:background_timer_package/core/shared_pref_keys.dart';
import 'package:background_timer_package/storage/shared_pref_storage.dart';

/// A coordinator class that manages the persistence of timer data.
///
/// It utilizes two separate storage instances to track the remaining time
/// and the timestamp of when the app entered the background.
class TimerStorageManager {
  /// Storage instance for the Unix timestamp recorded when the app is paused.
  final SharedPrefsStorage backGroundTimeStampStorage;

  /// Storage instance for the current number of seconds remaining on the timer.
  final SharedPrefsStorage timerStorage;

  /// Initializes the storage manager with predefined keys for
  /// background timestamps and timer values.
  TimerStorageManager()
      : backGroundTimeStampStorage = SharedPrefsStorage(
          key: SharedPreferenceKeys.backgroundTimeStamp,
        ),
        timerStorage = SharedPrefsStorage(key: SharedPreferenceKeys.timer);

  /// Clears all persisted data from both the timer and timestamp storage.
  ///
  /// Use this when resetting the app state or when a timer completes
  /// and no longer needs to be persisted.
  Future<void> resetAll() async {
    await Future.wait([
      backGroundTimeStampStorage.clear(),
      timerStorage.clear(),
    ]);
  }
}
