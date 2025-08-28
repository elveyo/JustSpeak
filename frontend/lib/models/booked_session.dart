import 'package:json_annotation/json_annotation.dart';

part 'booked_session.g.dart';

@JsonSerializable()
class BookedSession {
  final String language;
  final String level;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String userName;
  final String userImageUrl;

  BookedSession({
    required this.language,
    required this.level,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.userName,
    this.userImageUrl = "Cao",
  });

  factory BookedSession.fromJson(Map<String, dynamic> json) =>
      _$BookedSessionFromJson(json);

  Map<String, dynamic> toJson() => _$BookedSessionToJson(this);
}
