import 'package:json_annotation/json_annotation.dart';
import 'calendar_slot.dart';

part 'tutor_schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class Schedule {
  final int tutorId;
  final int duration; // minuta po sesiji
  final double price;
  final List<CalendarSlot> slots;

  Schedule({
    required this.tutorId,
    required this.duration,
    required this.price,
    required this.slots,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}
