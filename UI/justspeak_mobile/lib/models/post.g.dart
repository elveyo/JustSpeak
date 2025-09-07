// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
  id: (json['id'] as num?)?.toInt() ?? 0,
  title: json['title'] as String? ?? '',
  content: json['content'] as String? ?? '',
  createdAt: json['createdAt'] as String? ?? '',
  authorId: (json['authorId'] as num?)?.toInt() ?? 0,
  authorName: json['authorName'] as String? ?? '',
  numOfComments: (json['numOfComments'] as num?)?.toInt() ?? 0,
  numOfLikes: (json['numOfLikes'] as num?)?.toInt() ?? 0,
  userRole: json['userRole'] as String? ?? '',
  imageUrl: json['imageUrl'] as String? ?? '',
  likedByCurrUser: json['likedByCurrUser'] as bool? ?? false,
);

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'createdAt': instance.createdAt,
  'authorId': instance.authorId,
  'authorName': instance.authorName,
  'userRole': instance.userRole,
  'numOfLikes': instance.numOfLikes,
  'numOfComments': instance.numOfComments,
  'imageUrl': instance.imageUrl,
  'likedByCurrUser': instance.likedByCurrUser,
};
