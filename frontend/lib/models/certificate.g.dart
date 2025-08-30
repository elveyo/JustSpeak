// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Certificate _$CertificateFromJson(Map<String, dynamic> json) => Certificate(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$CertificateToJson(Certificate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ImageUrl': instance.imageUrl,
    };
