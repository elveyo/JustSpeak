import 'package:frontend/models/tag.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  final int id;
  final String? language;
  final String? level;
  final int numOfUsers;
  final int duration;
  final DateTime createdAt;
  final String? channelName;
  final String? token;
  final List<Tag> tags;

  Session({
    required this.id,
    this.language = "",
    this.level = "",
    required this.numOfUsers,
    required this.duration,
    required this.createdAt,
    this.channelName,
    this.token,
    required this.tags,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
