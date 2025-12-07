// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  languages: (json['languages'] as List<dynamic>)
      .map((e) => LanguageLevel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
  'user': instance.user,
  'languages': instance.languages,
};
