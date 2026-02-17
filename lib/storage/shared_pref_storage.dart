import 'package:shared_preferences/shared_preferences.dart';

import 'timer_storage.dart';

/// A [TimerStorage] implementation that uses the `shared_preferences` package.
///
/// This class handles the physical reading and writing of integer values
/// to the device's local disk, ensuring that timer data persists
/// even if the app process is terminated.
class SharedPrefsStorage implements TimerStorage {
  /// The unique identifier used to store and retrieve data
  /// from [SharedPreferences].
  final String key;

  /// Creates a [SharedPrefsStorage] instance with a specific [key].
  SharedPrefsStorage({required this.key});

  /// Writes the provided [seconds] to the device's persistent storage
  /// using the assigned [key].
  @override
  Future<void> saveSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, seconds);
  }

  /// Reads the stored integer value from the device's disk.
  ///
  /// Returns the saved [int] if it exists under the assigned [key],
  /// otherwise returns `null`.
  @override
  Future<int?> loadSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  /// Removes the value associated with the assigned [key]
  /// from the device's persistent storage.
  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
