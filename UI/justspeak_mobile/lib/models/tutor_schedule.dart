import 'package:json_annotation/json_annotation.dart';
import 'calendar_slot.dart';
import 'available_day.dart';

part 'tutor_schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class Schedule {
  final int? id;
  final int tutorId;
  final int duration; // minuta po sesiji
  final double price;
  final List<CalendarSlot> slots;
  final List<AvailableDay>? availableDays;

  Schedule({
    this.id,
    required this.tutorId,
    required this.duration,
    required this.price,
    required this.slots,
    this.availableDays,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
