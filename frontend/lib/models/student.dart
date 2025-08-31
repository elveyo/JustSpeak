import 'package:frontend/models/certificate.dart';
import 'package:frontend/models/language.dart';
import 'package:frontend/models/language_level.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/models/user.dart';

part 'student.g.dart';

@JsonSerializable()
class Student {
  final User user;
  final List<LanguageLevel> languages;

  Student({required this.user, required this.languages});

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
