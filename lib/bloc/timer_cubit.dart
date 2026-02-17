import 'dart:async';
import 'dart:developer';

import 'package:background_timer_package/storage/timer_storage_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  final TimerStorageManager storageManager;

  Timer? _timer;

  TimerCubit({required this.storageManager})
    : super(TimerState(secondsRemaining: 0));

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

  void start(int duration) {
    _timer?.cancel();
    _startTimer(duration);
  }

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

  void resume() {
    if (state.isPaused && state.secondsRemaining > 0) {
      _startTimer(state.secondsRemaining);
    }
  }

  void stop() {
    _timer?.cancel();
    emit(TimerState(secondsRemaining: 0, isRunning: false, isPaused: false));
  }

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

  int currentTimeStampInEpoch() => DateTime.now().millisecondsSinceEpoch;

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
