// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  role: json['role'] as String? ?? '',
  imageUrl: json['imageUrl'] as String? ?? '',
  password: json['password'] as String? ?? '',
  email: json['email'] as String? ?? '',
  bio: json['bio'] as String? ?? '',
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'password': instance.password,
  'email': instance.email,
  'bio': instance.bio,
  'role': instance.role,
  'imageUrl': instance.imageUrl,
};
