import 'dart:async';
import 'dart:developer';

import 'package:background_timer_package/storage/timer_storage_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'timer_state.dart';

/// A [Cubit] that manages the state of a countdown timer with background persistence.
///
/// It handles the core logic of ticking, pausing, and calculating elapsed time
/// that occurred while the app was inactive or closed.
class TimerCubit extends Cubit<TimerState> {
  /// The manager responsible for persisting timer and timestamp data.
  final TimerStorageManager storageManager;

  Timer? _timer;

  /// Creates a [TimerCubit].
  ///
  /// You can provide a custom [storageManager] (useful for testing or custom DBs).
  /// Defaults to a standard [TimerStorageManager] if none is provided.
  TimerCubit({TimerStorageManager? storageManager})
      : storageManager = storageManager ?? TimerStorageManager(),
        super(TimerState(secondsRemaining: 0));

  /// Initializes the cubit by checking local storage for an existing timer.
  ///
  /// If a timer was previously running, it calculates the elapsed time
  /// since the app was last active and resumes the countdown if time remains.
  Future<void> init() async {
    final int timer = await currentTimer();

    log(timer.toString());
    if (timer > 0) {
      emit(TimerState(secondsRemaining: timer, isPaused: true));
      _startTimer(timer);
    } else {
      emit(TimerState(secondsRemaining: 0, isPaused: true));
    }
  }

  /// Starts a new countdown timer for the specified [duration] in seconds.
  ///
  /// If a timer is already running, it will be cancelled and restarted
  /// with the new duration.
  void start(int duration) {
    _timer?.cancel();
    _startTimer(duration);
  }

  /// Pauses the active timer and persists the current [state.secondsRemaining]
  /// to local storage.
  void pause() {
    _timer?.cancel();
    storageManager.timerStorage.saveSeconds(state.secondsRemaining);
    emit(
      TimerState(
        secondsRemaining: state.secondsRemaining,
        isRunning: false,
        isPaused: true,
      ),
    );
  }

  /// Resumes a paused timer from its current [state.secondsRemaining].
  ///
  /// No action is taken if the timer is already running or has reached zero.
  void resume() {
    if (state.isPaused && state.secondsRemaining > 0) {
      _startTimer(state.secondsRemaining);
    }
  }

  /// Stops the timer and resets the state to zero.
  ///
  /// This cancels any active [Timer] periodic task.
  void stop() {
    _timer?.cancel();
    emit(TimerState(secondsRemaining: 0, isRunning: false, isPaused: false));
  }

  /// Internal method to initiate the [Timer.periodic] loop.
  void _startTimer(int seconds) {
    emit(
      TimerState(secondsRemaining: seconds, isRunning: true, isPaused: false),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final nextValue = state.secondsRemaining - 1;
      if (nextValue <= 0) {
        stop();
        storageManager.resetAll();
      } else {
        emit(
          TimerState(
            secondsRemaining: state.secondsRemaining - 1,
            isRunning: true,
            isPaused: false,
          ),
        );
      }
    });
  }

  /// Saves the current state and a timestamp to storage when the app
  /// enters the background.
  ///
  /// This should be called from the `didChangeAppLifecycleState` method
  /// in your UI layer when the state is `AppLifecycleState.paused`.
  Future<void> onBackground() async {
    final timestamp = currentTimeStampInEpoch();
    await storageManager.backGroundTimeStampStorage.saveSeconds(timestamp);
    await storageManager.timerStorage.saveSeconds(state.secondsRemaining);
    emit(
      TimerState(
        isRunning: false,
        secondsRemaining: state.secondsRemaining,
        isPaused: true,
      ),
    );
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  /// Returns the current system time in milliseconds since epoch.
  int currentTimeStampInEpoch() => DateTime.now().millisecondsSinceEpoch;

  /// Calculates the remaining time by comparing the current time with the
  /// saved background timestamp.
  ///
  /// Returns the adjusted seconds remaining, or `-1` if the timer expired
  /// while the app was inactive.
  FutureOr<int> currentTimer() async {
    final int savedTimer = await storageManager.timerStorage.loadSeconds() ?? 0;
    final int savedTimeStamp =
        await storageManager.backGroundTimeStampStorage.loadSeconds() ?? 0;
    final int currentTimeStamp = currentTimeStampInEpoch();
    final int diff = ((currentTimeStamp - savedTimeStamp) / 1000).floor();

    final int timer = savedTimer - diff;
    return timer > 0 ? timer : -1;
  }
}
