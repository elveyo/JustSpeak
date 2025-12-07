import 'package:json_annotation/json_annotation.dart';

part 'available_day.g.dart';

@JsonSerializable()
class AvailableDay {
  final int dayOfWeek; // 1=MON, 2=TUE, etc.
  final String? startTime; // format HH:mm:ss
  final String? endTime;   // format HH:mm:ss

  AvailableDay({
    required this.dayOfWeek,
    this.startTime,
    this.endTime,
  });

  factory AvailableDay.fromJson(Map<String, dynamic> json) => _$AvailableDayFromJson(json);
  Map<String, dynamic> toJson() => _$AvailableDayToJson(this);
}
