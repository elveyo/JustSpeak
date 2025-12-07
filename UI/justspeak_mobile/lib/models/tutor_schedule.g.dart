// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutor_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
  id: (json['id'] as num?)?.toInt(),
  tutorId: (json['tutorId'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  slots: (json['slots'] as List<dynamic>)
      .map((e) => CalendarSlot.fromJson(e as Map<String, dynamic>))
      .toList(),
  availableDays: (json['availableDays'] as List<dynamic>?)
      ?.map((e) => AvailableDay.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
  'id': instance.id,
  'tutorId': instance.tutorId,
  'duration': instance.duration,
  'price': instance.price,
  'slots': instance.slots.map((e) => e.toJson()).toList(),
  'availableDays': instance.availableDays?.map((e) => e.toJson()).toList(),
};
