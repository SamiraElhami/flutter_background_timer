import 'package:background_timer_package/storage/shared_pref_storage.dart';
import 'package:background_timer_package/storage/timer_storage_manager.dart';
import 'package:mocktail/mocktail.dart';


class MockStorageManager extends Mock implements TimerStorageManager {}
class MockStorage extends Mock implements SharedPrefsStorage {}