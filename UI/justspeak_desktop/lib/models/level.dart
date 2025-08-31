import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

@JsonSerializable()
class Level {
  final int id;
  final String name;
  final String description;
  final int maxPoints;

  Level({
    required this.id,
    required this.name,
    required this.description,
    required this.maxPoints,
  });

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
  Map<String, dynamic> toJson() => _$LevelToJson(this);
}
