import 'package:background_timer_package/bloc/timer_cubit.dart';
import 'package:background_timer_package/bloc/timer_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_timer_storage.dart';

void main() {
  late TimerCubit timerCubit;
  late MockStorageManager mockManager;
  late MockStorage mockTimerStorage;
  late MockStorage mockTimestampStorage;

  setUp(() {
    mockManager = MockStorageManager();
    mockTimerStorage = MockStorage();
    mockTimestampStorage = MockStorage();

    // Link the internal storages to the manager
    when(() => mockManager.timerStorage).thenReturn(mockTimerStorage);
    when(
      () => mockManager.backGroundTimeStampStorage,
    ).thenReturn(mockTimestampStorage);

    // Default stubs
    when(() => mockTimerStorage.saveSeconds(any())).thenAnswer((_) async => {});
    when(
      () => mockTimestampStorage.saveSeconds(any()),
    ).thenAnswer((_) async => {});
    when(() => mockManager.resetAll()).thenAnswer((_) async => {});
  });

  blocTest<TimerCubit, TimerState>(
    'init() emits state with calculated background time',
    build: () {
      final now = DateTime.now();
      when(() => mockTimerStorage.loadSeconds()).thenAnswer((_) async => 100);
      when(
        () => mockTimestampStorage.loadSeconds(),
      ).thenAnswer((_) async => now.millisecondsSinceEpoch - 20000); // 20s ago

      return TimerCubit(storageManager: mockManager);
    },
    act: (cubit) => cubit.init(),
    expect: () => [
      isA<TimerState>()
          .having((s) => s.secondsRemaining, 'seconds', 80) // 100 - 20
          .having((s) => s.isPaused, 'paused', true),
      isA<TimerState>()
          .having((s) => s.secondsRemaining, 'seconds', 80)
          .having((s) => s.isRunning, 'running', true),
    ],
  );

  blocTest<TimerCubit, TimerState>(
    'init() calculates remaining time correctly after being in background',
    build: () {
      final now = DateTime.now().millisecondsSinceEpoch;
      when(() => mockTimerStorage.loadSeconds()).thenAnswer((_) async => 60);
      when(
        () => mockTimestampStorage.loadSeconds(),
      ).thenAnswer((_) async => now - 10000);

      return TimerCubit(storageManager: mockManager);
    },
    act: (cubit) async => await cubit.init(),
    expect: () => [
      isA<TimerState>()
          .having((s) => s.secondsRemaining, 'seconds', 50)
          .having((s) => s.isPaused, 'paused', true)
          .having((s) => s.isRunning, 'running', false),

      isA<TimerState>()
          .having((s) => s.secondsRemaining, 'seconds', 50)
          .having((s) => s.isPaused, 'paused', false)
          .having((s) => s.isRunning, 'running', true),
    ],
  );

  blocTest<TimerCubit, TimerState>(
    'pause() stops timer and saves state to storage',
    build: () => TimerCubit(storageManager: mockManager),
    act: (cubit) {
      cubit.start(30);
      cubit.pause();
    },
    verify: (_) {
      verify(() => mockTimerStorage.saveSeconds(30)).called(1);
    },
    expect: () => [
      isA<TimerState>()
          .having((s) => s.secondsRemaining, 'seconds', 30)
          .having((s) => s.isRunning, 'running', true),

      isA<TimerState>()
          .having((s) => s.secondsRemaining, 'seconds', 30)
          .having((s) => s.isPaused, 'paused', true)
          .having((s) => s.isRunning, 'running', false),
    ],
  );

  group('currentTimer calculation', () {
    test('returns correct remaining time after background lapse', () async {
      final now = DateTime.now();

      final savedTimeAt = now
          .subtract(const Duration(seconds: 10))
          .millisecondsSinceEpoch;

      when(() => mockTimerStorage.loadSeconds()).thenAnswer((_) async => 60);
      when(
        () => mockTimestampStorage.loadSeconds(),
      ).thenAnswer((_) async => savedTimeAt);

      final cubit = TimerCubit(storageManager: mockManager);
      final result = await cubit.currentTimer();

      expect(result, equals(50));
    });

    test('returns -1 if the timer expired while in background', () async {
      final now = DateTime.now();
      final savedTimeAt = now
          .subtract(const Duration(seconds: 30))
          .millisecondsSinceEpoch;

      when(() => mockTimerStorage.loadSeconds()).thenAnswer((_) async => 10);
      when(
        () => mockTimestampStorage.loadSeconds(),
      ).thenAnswer((_) async => savedTimeAt);

      final cubit = TimerCubit(storageManager: mockManager);
      final result = await cubit.currentTimer();

      expect(result, -1);
    });
  });

  test('calculates diff correctly with fixed clock', () async {
    final now = DateTime.now();

    final cubit = TimerCubit(storageManager: mockManager);

    final savedTimestamp = now
        .subtract(const Duration(seconds: 10))
        .millisecondsSinceEpoch;

    when(() => mockTimerStorage.loadSeconds()).thenAnswer((_) async => 60);
    when(
      () => mockTimestampStorage.loadSeconds(),
    ).thenAnswer((_) async => savedTimestamp);

    final remaining = await cubit.currentTimer();

    expect(remaining, 50);
  });

  test(
    'onBackground() saves current timestamp and remaining seconds',
    () async {
      timerCubit = TimerCubit(storageManager: mockManager);
      timerCubit.start(100);

      await timerCubit.onBackground();

      verify(() => mockTimestampStorage.saveSeconds(any())).called(1);
      verify(() => mockTimerStorage.saveSeconds(100)).called(1);
    },
  );
}
