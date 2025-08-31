// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageLevel _$LanguageLevelFromJson(Map<String, dynamic> json) =>
    LanguageLevel(
      language: json['language'] as String,
      level: json['level'] as String,
      points: (json['points'] as num).toInt(),
      maxPoints: (json['maxPoints'] as num).toInt(),
    );

Map<String, dynamic> _$LanguageLevelToJson(LanguageLevel instance) =>
    <String, dynamic>{
      'language': instance.language,
      'level': instance.level,
      'points': instance.points,
      'maxPoints': instance.maxPoints,
    };
