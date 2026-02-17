import 'package:background_timer_package/bloc/timer_cubit.dart';
import 'package:background_timer_package/bloc/timer_state.dart';
import 'package:background_timer_package/storage/timer_storage_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'timer_controller.dart';

/// A widget that manages a timer capable of running
/// logic even when the app is in the background or close.
class BackgroundTimer extends StatefulWidget {
  /// The initial duration of the timer in seconds.
  final int seconds;

  /// The controller responsible for handling the timer logic and state.
  final TimerController? controller;

  /// The storageManager responsible for storing the timer values
  final TimerStorageManager? storageManger;

  /// Creates a new [BackgroundTimer] instance.
  ///
  /// Requires a [controller] to manage state and the initial
  /// amount of [seconds] for the countdown.
  /// [storageManger] for storing the timer values

  const BackgroundTimer({
    super.key,
    required this.seconds,
    this.controller,
    this.storageManger,
  });

  @override
  State<BackgroundTimer> createState() => _BackgroundTimerState();
}

class _BackgroundTimerState extends State<BackgroundTimer>
    with WidgetsBindingObserver {
  late TimerCubit _cubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cubit = TimerCubit()..init();
    // Link the user's controller to internal Cubit
    widget.controller?.attach(_cubit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<TimerCubit, TimerState>(
        builder: (context, state) => Text('${state.secondsRemaining}'),
      ),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _cubit.init();
        break;
      case AppLifecycleState.paused:
        _cubit.onBackground();
        break;
      default:
        break;
    }
  }
}
