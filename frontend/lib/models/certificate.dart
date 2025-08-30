import 'package:json_annotation/json_annotation.dart';

part 'certificate.g.dart';

@JsonSerializable()
class Certificate {
  final int id;
  final String name;
  final String? imageUrl;

  Certificate({required this.id, required this.name, this.imageUrl});

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    id: json['id'] as int,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
  };

  static List<Certificate> fromJsonList(List<dynamic> jsonList) =>
      jsonList
          .map((json) => Certificate.fromJson(json as Map<String, dynamic>))
          .toList();

  static List<Map<String, dynamic>> toJsonList(
    List<Certificate> certificates,
  ) => certificates.map((certificate) => certificate.toJson()).toList();
}
