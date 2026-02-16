
import 'package:shared_preferences/shared_preferences.dart';
import 'timer_storage.dart';

class SharedPrefsStorage implements TimerStorage {
  final String key;
  SharedPrefsStorage({required this.key});


  @override
  Future<void> saveSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, seconds);
  }

  @override
  Future<int?> loadSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}