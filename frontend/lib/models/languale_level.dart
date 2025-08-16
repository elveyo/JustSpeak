import 'package:json_annotation/json_annotation.dart';

part 'languale_level.g.dart';

@JsonSerializable()
class LanguageLevel {
  final int id;
  final String name;
  final String description;
  final int maxPoints;

  LanguageLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.maxPoints,
  });

  factory LanguageLevel.fromJson(Map<String, dynamic> json) =>
      _$LanguageLevelFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageLevelToJson(this);
}
