// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tutor _$TutorFromJson(Map<String, dynamic> json) => Tutor(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  certificates:
      (json['certificates'] as List<dynamic>)
          .map((e) => Certificate.fromJson(e as Map<String, dynamic>))
          .toList(),
  languages:
      (json['languages'] as List<dynamic>)
          .map((e) => Language.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TutorToJson(Tutor instance) => <String, dynamic>{
  'user': instance.user,
  'languages': instance.languages,
  'certificates': instance.certificates,
};
