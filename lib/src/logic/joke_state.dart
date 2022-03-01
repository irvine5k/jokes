part of 'joke_bloc.dart';

abstract class JokeState extends Equatable {
  const JokeState();

  @override
  List<Object?> get props => [];
}

class LoadingState extends JokeState {
  const LoadingState();
}

class SuccessState extends JokeState {
  final JokeModel joke;

  const SuccessState(this.joke);

  @override
  List<Object?> get props => [joke];
}

class ErrorState extends JokeState {
  const ErrorState();
}
