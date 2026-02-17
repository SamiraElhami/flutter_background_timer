import 'package:background_timer_package/bloc/timer_cubit.dart';

/// A controller used to programmatically interact with a background timer.
///
/// This allows you to control the timer (pause, resume, reset) from
/// outside the widget tree where the timer is defined.
class TimerController {
  TimerCubit? _cubit;

  /// Internal method used to link the [TimerCubit] to this controller.
  ///
  /// This is handled automatically by the package and should not
  /// be called by end-users.
  void attach(TimerCubit cubit) => _cubit = cubit;

  /// Pauses the current timer and saves the progress to local storage.
  void pause() => _cubit?.pause();

  /// Resumes the timer from the last saved state.
  ///
  /// If the app was in the background, it will automatically
  /// account for the elapsed time.
  void resume() => _cubit?.resume();

  /// Resets the timer to a new [seconds] duration and starts it immediately.
  void reset(int seconds) => _cubit?.start(seconds);

  /// Returns the current number of seconds remaining in the countdown.
  ///
  /// Returns `0` if the timer is not active or has finished.
  int get remainingSeconds => _cubit?.state.secondsRemaining ?? 0;
}
