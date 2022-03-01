import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:joke/src/data/joke_repository.dart';
import 'package:joke/src/data/models/joke_model.dart';
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

  test("When API succeeds should return a random joke", () async {
    final mockResponse = Response(randomJokeResponse, 200);

    when(
      () => client.get(
        any(),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) => Future.value(mockResponse));

    const expectedJoke = JokeModel(
      id: 7,
      type: "general",
      setup: "What do you call a singing Laptop",
      punchline: "A Dell",
    );

    final joke = await repository.getRandomJoke();

    expect(joke, expectedJoke);
  });
  test("When API fails should throw an error", () async {
    when(
      () => client.get(
        any(),
        headers: any(named: 'headers'),
      ),
    ).thenThrow(Exception());

    expect(repository.getRandomJoke(), throwsException);
  });
}
