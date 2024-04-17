import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/core.dart';

class CountdownPage extends StatelessWidget {
  const CountdownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown Timer')),
      body: Center(
        child: BlocBuilder<CountdownBloc, CountdownState>(
          builder: (context, state) {
            if (state is CountdownInitial) {
              return ElevatedButton(
                onPressed: () =>
                    context.read<CountdownBloc>().add(StartCountdown(DateTime.now().add(const Duration(days: 1)))),
                child: const Text('Start Countdown'),
              );
            } else if (state is CountdownRunning) {
              return Text(state.timeLeft, style: Theme.of(context).textTheme.headlineMedium);
            } else if (state is CountdownFinished) {
              return Text("Countdown Finished!", style: Theme.of(context).textTheme.headlineMedium);
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
