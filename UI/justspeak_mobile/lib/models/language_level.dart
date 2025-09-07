import 'package:json_annotation/json_annotation.dart';

part 'language_level.g.dart';

@JsonSerializable()
class LanguageLevel {
  final String language;
  final String level;
  final int points;
  final int maxPoints;

  LanguageLevel({
    required this.language,
    required this.level,
    required this.points,
    required this.maxPoints,
  });

  factory LanguageLevel.fromJson(Map<String, dynamic> json) =>
      _$LanguageLevelFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageLevelToJson(this);
}
