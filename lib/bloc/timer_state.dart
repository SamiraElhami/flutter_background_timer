class TimerState {
  final int secondsRemaining;
  final bool isRunning;
  final bool isPaused;

  TimerState({
    required this.secondsRemaining,
    this.isRunning = false,
    this.isPaused = false,
  });
}
