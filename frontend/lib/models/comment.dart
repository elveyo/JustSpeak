/* import 'package:json_annotation/json_annotation.dart';
import 'post.dart';
import 'user.dart';
import 'like.dart';

part 'comment.g.dart';

@JsonSerializable(explicitToJson: true)
class Comment {
  final int id;
  final String? content;
  final DateTime createdAt;

  final int postId;
  final Post post;

  final int authorId;
  final User author;

  final int? parentCommentId;
  final Comment? parentComment;

  final List<Comment> replies;
  final List<Like> likes;

  Comment({
    required this.id,
    this.content,
    required this.createdAt,
    required this.postId,
    required this.post,
    required this.authorId,
    required this.author,
    this.parentCommentId,
    this.parentComment,
    required this.replies,
    required this.likes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
 */
