// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
  id: (json['id'] as num).toInt(),
  language: json['language'] as String? ?? "",
  level: json['level'] as String? ?? "",
  numOfUsers: (json['numOfUsers'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  channelName: json['channelName'] as String?,
  token: json['token'] as String?,
);

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'id': instance.id,
  'language': instance.language,
  'level': instance.level,
  'numOfUsers': instance.numOfUsers,
  'duration': instance.duration,
  'createdAt': instance.createdAt.toIso8601String(),
  'channelName': instance.channelName,
  'token': instance.token,
};
