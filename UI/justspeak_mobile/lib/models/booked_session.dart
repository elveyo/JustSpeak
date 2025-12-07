import 'package:json_annotation/json_annotation.dart';

part 'booked_session.g.dart';

@JsonSerializable()
class BookedSession {
  final int id;
  final String channelName;
  final String language;
  final int languageId;
  final String level;
  final int levelId;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String userName;
  final String userImageUrl;
  final bool isActive;
  final bool isCompleted;
  final String? note;

  BookedSession({
    required this.id,
    required this.channelName,
    required this.language,
    required this.languageId,
    required this.level,
    required this.levelId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.userName,
    required this.isActive,
    this.isCompleted = false,
    this.note,
    this.userImageUrl = "Cao",
  });

  factory BookedSession.fromJson(Map<String, dynamic> json) =>
      _$BookedSessionFromJson(json);

  Map<String, dynamic> toJson() => _$BookedSessionToJson(this);
}
