abstract class TimerStorage {
  Future<void> saveSeconds(int seconds);

  Future<int?> loadSeconds();

  Future<void> clear();
}
