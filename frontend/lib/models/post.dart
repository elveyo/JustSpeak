import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  final int id;
  final String title;
  final String content;
  final String createdAt;
  final int authorId;
  final String authorName;
  final String userRole;
  int numOfLikes;
  final int numOfComments;
  final String imageUrl;
  bool likedByCurrUser;

  Post({
    this.id = 0,
    this.title = '',
    this.content = '',
    this.createdAt = '',
    this.authorId = 0,
    this.authorName = '',
    this.numOfComments = 0,
    this.numOfLikes = 0,
    this.userRole = '',
    this.imageUrl = '',
    this.likedByCurrUser = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
