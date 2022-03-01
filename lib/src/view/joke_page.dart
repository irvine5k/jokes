import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joke/src/logic/joke_bloc.dart';
import 'dart:async';

class JokePage extends StatefulWidget {
  const JokePage({Key? key}) : super(key: key);

  @override
  _JokePageState createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  bool showPunchline = false;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(
      const Duration(seconds: 3),
      context.read<JokeBloc>().getRandomJoke,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make me laugh'),
      ),
      body: BlocBuilder<JokeBloc, JokeState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ErrorState) {
            return Center(
              child: ElevatedButton(
                child: const Text('Retry'),
                onPressed: context.read<JokeBloc>().getRandomJoke,
              ),
            );
          }

          final joke = (state as SuccessState).joke;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () => setState(() => showPunchline = true),
                  child: Text(
                    joke.setup,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: AnimatedCrossFade(
                    firstChild: const SizedBox(),
                    secondChild: Text(
                      joke.punchline,
                      textAlign: TextAlign.center,
                    ),
                    crossFadeState: showPunchline
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 500),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
