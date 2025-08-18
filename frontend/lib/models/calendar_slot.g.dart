// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarSlot _$CalendarSlotFromJson(Map<String, dynamic> json) => CalendarSlot(
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
  isBooked: json['isBooked'] as bool,
);

Map<String, dynamic> _$CalendarSlotToJson(CalendarSlot instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'isBooked': instance.isBooked,
    };
