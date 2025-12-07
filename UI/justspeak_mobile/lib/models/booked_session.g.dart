// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booked_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookedSession _$BookedSessionFromJson(Map<String, dynamic> json) =>
    BookedSession(
      id: (json['id'] as num).toInt(),
      channelName: json['channelName'] as String,
      language: json['language'] as String,
      languageId: (json['languageId'] as num).toInt(),
      level: json['level'] as String,
      levelId: (json['levelId'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      userName: json['userName'] as String,
      isActive: json['isActive'] as bool,
      isCompleted: json['isCompleted'] as bool? ?? false,
      note: json['note'] as String?,
      userImageUrl: json['userImageUrl'] as String? ?? "Cao",
    );

Map<String, dynamic> _$BookedSessionToJson(BookedSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channelName': instance.channelName,
      'language': instance.language,
      'languageId': instance.languageId,
      'level': instance.level,
      'levelId': instance.levelId,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'userName': instance.userName,
      'userImageUrl': instance.userImageUrl,
      'isActive': instance.isActive,
      'isCompleted': instance.isCompleted,
      'note': instance.note,
    };
