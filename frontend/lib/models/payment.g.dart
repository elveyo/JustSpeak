// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
  id: (json['id'] as num).toInt(),
  sessionId: (json['sessionId'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
  'id': instance.id,
  'sessionId': instance.sessionId,
  'amount': instance.amount,
  'status': instance.status,
  'createdAt': instance.createdAt.toIso8601String(),
};
