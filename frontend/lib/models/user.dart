import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/models/role.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String firstName;
  final String lastName;
  final Role role;
  final String imageUrl;
  String get fullName => '$firstName $lastName';

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.imageUrl = '',
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
