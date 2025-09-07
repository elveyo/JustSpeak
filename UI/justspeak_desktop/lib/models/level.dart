import 'package:json_annotation/json_annotation.dart';

part 'level.g.dart';

@JsonSerializable()
class Level {
  int id;
  String name;
  String description;
  int maxPoints;
  int order;

  Level({
    required this.id,
    required this.name,
    required this.description,
    required this.maxPoints,
    required this.order,
  });

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
  Map<String, dynamic> toJson() => _$LevelToJson(this);
}
