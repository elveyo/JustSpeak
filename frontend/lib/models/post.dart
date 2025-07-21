import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final int authorId;
  final String authorName;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.authorId,
    required this.authorName,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
