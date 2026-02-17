class TimerState {
  final int secondsRemaining;
  final bool isRunning;
  final bool isPaused;

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
