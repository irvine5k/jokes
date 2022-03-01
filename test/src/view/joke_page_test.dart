import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:joke/src/data/joke_repository.dart';
import 'package:joke/src/data/models/joke_model.dart';
import 'package:joke/src/logic/joke_bloc.dart';
import 'package:joke/src/view/joke_page.dart';
import 'package:mocktail/mocktail.dart';

import '../aux/mock_responses.dart';

class MockClient extends Mock implements Client {}

void main() {
  late Client client;

  setUp(() {
    client = MockClient();
  });

  setUpAll(() {
    registerFallbackValue(Uri.parse(''));
  });

  testWidgets("When success should find the correct joke", (tester) async {
    final mockResponse = Response(randomJokeResponse, 200);

    when(
      () => client.get(
        any(),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) => Future.value(mockResponse));

    await _createWidget(tester, client);

    await tester.pumpAndSettle();

    const expectedJoke = JokeModel(
      id: 7,
      type: "general",
      setup: "What do you call a singing Laptop",
      punchline: "A Dell",
    );

    expect(find.text(expectedJoke.setup), findsOneWidget);
  });

  testWidgets("When error should find a retry button", (tester) async {
    final mockResponse = Response(randomJokeResponse, 200);

    when(
      () => client.get(
        any(),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer((_) => Future.value(mockResponse));

    await _createWidget(tester, client);

    await tester.pumpAndSettle();

    const expectedJoke = JokeModel(
      id: 7,
      type: "general",
      setup: "What do you call a singing Laptop",
      punchline: "A Dell",
    );

    expect(find.text(expectedJoke.setup), findsOneWidget);
  });

  testWidgets(
    "When click at joke setup should reveal the punchline",
    (tester) async {
      final mockResponse = Response(randomJokeResponse, 200);

      when(
        () => client.get(
          any(),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) => Future.value(mockResponse));

      await _createWidget(tester, client);

      await tester.pumpAndSettle();

      const expectedJoke = JokeModel(
        id: 7,
        type: "general",
        setup: "What do you call a singing Laptop",
        punchline: "A Dell",
      );

      await tester.tap(find.text(expectedJoke.setup));

      await tester.pumpAndSettle();

      expect(find.text(expectedJoke.punchline), findsOneWidget);
    },
  );
}

Future<void> _createWidget(WidgetTester tester, Client mockClient) {
  return tester.pumpWidget(
    MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<JokeBloc>(
        create: (context) {
          final repository = HttpJokeRepository(client: mockClient);

          return JokeBloc(repository: repository)..getRandomJoke();
        },
        child: const JokePage(),
      ),
    ),
  );
}
