import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joke/src/data/joke_repository.dart';
import 'package:joke/src/data/models/joke_model.dart';

part 'joke_state.dart';

class JokeBloc extends Cubit<JokeState> {
  JokeBloc({
    required JokeRepository repository,
  })  : _repository = repository,
        super(const LoadingState());

  final JokeRepository _repository;

  Future<void> getRandomJoke() async {
    emit(const LoadingState());

    try {
      final joke = await _repository.getRandomJoke();

      emit(SuccessState(joke));
    } catch (_) {
      emit(const ErrorState());
    }
  }
}
