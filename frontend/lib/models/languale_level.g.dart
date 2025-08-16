// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'languale_level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageLevel _$LanguageLevelFromJson(Map<String, dynamic> json) =>
    LanguageLevel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      maxPoints: (json['maxPoints'] as num).toInt(),
    );

Map<String, dynamic> _$LanguageLevelToJson(LanguageLevel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'maxPoints': instance.maxPoints,
    };
