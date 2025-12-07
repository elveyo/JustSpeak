// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tutor _$TutorFromJson(Map<String, dynamic> json) => Tutor(
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  certificates: (json['certificates'] as List<dynamic>)
      .map((e) => Certificate.fromJson(e as Map<String, dynamic>))
      .toList(),
  languages: (json['languages'] as List<dynamic>)
      .map((e) => Language.fromJson(e as Map<String, dynamic>))
      .toList(),
  sessionCount: (json['sessionCount'] as num).toInt(),
  studentCount: (json['studentCount'] as num).toInt(),
  price: (json['price'] as num?)?.toDouble(),
  hasSchedule: json['hasSchedule'] as bool? ?? false,
);

Map<String, dynamic> _$TutorToJson(Tutor instance) => <String, dynamic>{
  'user': instance.user,
  'languages': instance.languages,
  'certificates': instance.certificates,
  'sessionCount': instance.sessionCount,
  'studentCount': instance.studentCount,
  'price': instance.price,
  'hasSchedule': instance.hasSchedule,
};
