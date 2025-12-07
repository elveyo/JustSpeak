// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableDay _$AvailableDayFromJson(Map<String, dynamic> json) => AvailableDay(
  dayOfWeek: (json['dayOfWeek'] as num).toInt(),
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
);

Map<String, dynamic> _$AvailableDayToJson(AvailableDay instance) =>
    <String, dynamic>{
      'dayOfWeek': instance.dayOfWeek,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
