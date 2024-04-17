import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/core.dart';

class CountdownBloc extends Bloc<CountdownEvent, CountdownState> {
  CountdownBloc() : super(CountdownInitial());

  Timer? _timer;

  @override
  Stream<CountdownState> mapEventToState(CountdownEvent event) async* {
    if (event is StartCountdown) {
      yield* _mapStartCountdownToState(event);
    } else if (event is TickCountdown) {
      yield* _mapTickCountdownToState(event);
    }
  }

  Stream<CountdownState> _mapStartCountdownToState(StartCountdown event) async* {
    yield CountdownRunning(_formatDuration(event.targetDateTime.difference(DateTime.now())));
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      add(TickCountdown(event.targetDateTime.difference(DateTime.now())));
    });
  }

  Stream<CountdownState> _mapTickCountdownToState(TickCountdown event) async* {
    if (event.duration.isNegative) {
      _timer?.cancel();
      yield CountdownFinished();
    } else {
      yield CountdownRunning(_formatDuration(event.duration));
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
