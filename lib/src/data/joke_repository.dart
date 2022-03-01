import 'dart:convert';

import 'package:http/http.dart';
import 'package:joke/src/data/models/joke_model.dart';

abstract class JokeRepository {
  Future<JokeModel> getRandomJoke();
}

class HttpJokeRepository implements JokeRepository {
  const HttpJokeRepository({
    required Client client,
  }) : _client = client;

  final Client _client;

  @override
  Future<JokeModel> getRandomJoke() async {
    final url = Uri.parse("https://joke.api.gkamelo.xyz/random");

    final response = await _client.get(
      url,
      headers: {'x-api-key': 'QUtFhHPnlQ5f13LDVpQL3a54XgQzTlCJa1PMSB3o'},
    ).timeout(
      const Duration(seconds: 10),
    );

    final decodedJson = jsonDecode(response.body) as Map<String, Object?>;

    final joke = JokeModel.fromJson(decodedJson);

    return joke;
  }
}
