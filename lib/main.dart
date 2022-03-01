import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:joke/src/data/joke_repository.dart';
import 'package:joke/src/view/joke_page.dart';

import 'src/logic/joke_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider<JokeBloc>(
        create: (context) {
          final client = Client();
          final repository = HttpJokeRepository(client: client);

          return JokeBloc(repository: repository)..getRandomJoke();
        },
        child: const JokePage(),
      ),
    );
  }
}
