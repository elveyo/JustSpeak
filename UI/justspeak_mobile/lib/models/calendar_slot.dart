import 'package:json_annotation/json_annotation.dart';

part 'calendar_slot.g.dart';

@JsonSerializable()
class CalendarSlot {
  final DateTime date;
  final DateTime start;
  final DateTime end;
  final bool isBooked;

  CalendarSlot({
    required this.date,
    required this.start,
    required this.end,
    required this.isBooked,
  });

  factory CalendarSlot.fromJson(Map<String, dynamic> json) =>
      _$CalendarSlotFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarSlotToJson(this);
}
