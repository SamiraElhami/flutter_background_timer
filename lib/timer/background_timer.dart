import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:background_timer_package/storage/timer_storage_manager.dart';

import 'package:background_timer_package/bloc/timer_cubit.dart';
import 'package:background_timer_package/bloc/timer_state.dart';
import 'timer_controller.dart';

class BackgroundTimer extends StatefulWidget {
  final int seconds;
  final TimerController? controller;
  final TimerStorageManager storageManager;

  const BackgroundTimer({
    super.key,
    required this.seconds,
    required this.storageManager,
    this.controller,
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
    _cubit = TimerCubit(storageManager: widget.storageManager)..init();
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
