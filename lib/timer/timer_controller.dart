import 'package:background_timer_package/bloc/timer_cubit.dart';

class TimerController {
  TimerCubit? _cubit;

  // Internal method used by the package, not the user
  void attach(TimerCubit cubit) => _cubit = cubit;

  void pause() => _cubit?.pause();

  void resume() => _cubit?.resume();

  void reset(int seconds) => _cubit?.start(seconds);

  int get remainingSeconds => _cubit?.state.secondsRemaining ?? 0;
}
