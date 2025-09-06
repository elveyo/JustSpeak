import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

@JsonSerializable()
class Level {
  final int id;
  final String name;
  String description;
  int maxPoints;

  Level({
    required this.id,
    required this.name,
    this.description = "",
    this.maxPoints = 0,
  });

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
  Map<String, dynamic> toJson() => _$LevelToJson(this);
}
