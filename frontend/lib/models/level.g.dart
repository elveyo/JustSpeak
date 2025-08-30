// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'level.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Level _$LanguageLevelFromJson(Map<String, dynamic> json) => Level(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String,
  maxPoints: (json['maxPoints'] as num).toInt(),
);

Map<String, dynamic> _$LanguageLevelToJson(Level instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'maxPoints': instance.maxPoints,
};
