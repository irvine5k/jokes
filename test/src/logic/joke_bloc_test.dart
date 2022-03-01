import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:joke/src/data/joke_repository.dart';
import 'package:joke/src/data/models/joke_model.dart';
import 'package:joke/src/logic/joke_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../aux/mock_responses.dart';

class MockClient extends Mock implements Client {}

void main() {
  late Client client;
  late JokeRepository repository;

  setUp(() {
    client = MockClient();
    repository = HttpJokeRepository(client: client);
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse(''));
  });

  blocTest<JokeBloc, JokeState>(
      "When repository succeeds should emit [Loading, Success]",
      build: () {
        final mockResponse = Response(randomJokeResponse, 200);

        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenAnswer((_) => Future.value(mockResponse));

        return JokeBloc(repository: repository);
      },
      act: (bloc) => bloc.getRandomJoke(),
      expect: () {
        const expectedJoke = JokeModel(
          id: 7,
          type: "general",
          setup: "What do you call a singing Laptop",
          punchline: "A Dell",
        );

        return [
          const LoadingState(),
          const SuccessState(expectedJoke),
        ];
      });

  blocTest<JokeBloc, JokeState>(
      "When repository fails should emit [Loading, Error]",
      build: () {
        when(
          () => client.get(
            any(),
            headers: any(named: 'headers'),
          ),
        ).thenThrow(Exception());

        return JokeBloc(repository: repository);
      },
      act: (bloc) => bloc.getRandomJoke(),
      expect: () {
        return [
          const LoadingState(),
          const ErrorState(),
        ];
      });
}
