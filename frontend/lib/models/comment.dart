import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  final int id;
  final String? content;
  final DateTime createdAt;
  final int authorId;
  final String? authorName;

  Comment({
    required this.id,
    this.content,
    required this.createdAt,
    required this.authorId,
    this.authorName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
