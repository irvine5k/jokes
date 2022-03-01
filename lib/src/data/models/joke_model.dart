import 'package:equatable/equatable.dart';

class JokeModel extends Equatable {
  const JokeModel({
    required this.id,
    required this.type,
    required this.setup,
    required this.punchline,
  });

  factory JokeModel.fromJson(Map<String, Object?> json) => JokeModel(
        id: json["id"] as int,
        type: json["type"] as String,
        setup: json["setup"] as String,
        punchline: json["punchline"] as String,
      );

  final int id;
  final String type;
  final String setup;
  final String punchline;

  @override
  List<Object> get props => [
        id,
        type,
        setup,
        punchline,
      ];
}
