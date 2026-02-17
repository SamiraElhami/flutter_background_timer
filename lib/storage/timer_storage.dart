/// An abstract interface for persisting timer data.
///
/// This contract allows the package to remain storage-agnostic.
/// You can implement this class to store data in `shared_preferences`,
/// a local database, or even a remote server.
abstract class TimerStorage {
  /// Persists the given [seconds] to local storage.
  ///
  /// This is typically called whenever the timer state changes or
  /// when the app moves to the background.
  Future<void> saveSeconds(int seconds);

  /// Retrieves the persisted number of seconds from storage.
  ///
  /// Returns the saved [int] if it exists, or `null` if no
  /// data has been saved yet.
  Future<int?> loadSeconds();

  /// Removes the persisted data from storage.
  ///
  /// This is used to clean up storage after a timer finishes
  /// or is manually reset.
  Future<void> clear();
}
