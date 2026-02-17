/// Represents the current snapshot of the background timer.
///
/// Contains the remaining time and the current playback status
/// of the countdown.
class TimerState {
  /// The number of seconds left in the countdown.
  final int secondsRemaining;

  /// Indicates if the timer is currently actively ticking.
  final bool isRunning;

  /// Indicates if the timer has been manually paused by the user.
  ///
  /// When [isPaused] is true, the [secondsRemaining] value is
  /// persisted to local storage.
  final bool isPaused;

  /// Creates a [TimerState] with the specified values.
  ///
  /// By default, [isRunning] and [isPaused] are set to `false`.
  TimerState({
    required this.secondsRemaining,
    this.isRunning = false,
    this.isPaused = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerState &&
          runtimeType == other.runtimeType &&
          secondsRemaining == other.secondsRemaining &&
          isRunning == other.isRunning &&
          isPaused == other.isPaused;

  @override
  int get hashCode =>
      secondsRemaining.hashCode ^ isRunning.hashCode ^ isPaused.hashCode;
}
