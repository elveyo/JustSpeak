// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booked_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookedSession _$BookedSessionFromJson(Map<String, dynamic> json) =>
    BookedSession(
      language: json['language'] as String,
      level: json['level'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      userName: json['userName'] as String,
      userImageUrl: json['userImageUrl'] as String? ?? "Cao",
    );

Map<String, dynamic> _$BookedSessionToJson(BookedSession instance) =>
    <String, dynamic>{
      'language': instance.language,
      'level': instance.level,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'userName': instance.userName,
      'userImageUrl': instance.userImageUrl,
    };
