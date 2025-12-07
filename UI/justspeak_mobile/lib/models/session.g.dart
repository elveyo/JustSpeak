// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
  id: (json['id'] as num).toInt(),
  language: json['language'] as String? ?? "",
  level: json['level'] as String? ?? "",
  languageId: (json['languageId'] as num?)?.toInt(),
  levelId: (json['levelId'] as num?)?.toInt(),
  numOfUsers: (json['numOfUsers'] as num).toInt(),
  currentNumOfUsers: (json['currentNumOfUsers'] as num?)?.toInt() ?? 0,
  duration: (json['duration'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  channelName: json['channelName'] as String?,
  token: json['token'] as String?,
  tags: (json['tags'] as List<dynamic>)
      .map((e) => Tag.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'id': instance.id,
  'language': instance.language,
  'level': instance.level,
  'languageId': instance.languageId,
  'levelId': instance.levelId,
  'numOfUsers': instance.numOfUsers,
  'currentNumOfUsers': instance.currentNumOfUsers,
  'duration': instance.duration,
  'createdAt': instance.createdAt.toIso8601String(),
  'channelName': instance.channelName,
  'token': instance.token,
  'tags': instance.tags,
};
