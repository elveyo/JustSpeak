import 'package:frontend/models/certificate.dart';
import 'package:frontend/models/language.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:frontend/models/user.dart';

part 'tutor.g.dart';

@JsonSerializable()
class Tutor {
  final User user;
  final List<Language> languages;
  final List<Certificate> certificates;

  Tutor({
    required this.user,
    required this.certificates,
    required this.languages,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) => _$TutorFromJson(json);
  Map<String, dynamic> toJson() => _$TutorToJson(this);
}
