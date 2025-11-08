// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
  id: (json['id'] as num).toInt(),
  amount: (json['amount'] as num).toDouble(),
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  sender: json['sender'] as String? ?? '',
  recipient: json['recipient'] as String? ?? '',
);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
  'id': instance.id,
  'amount': instance.amount,
  'status': instance.status,
  'sender': instance.sender,
  'recipient': instance.recipient,
  'createdAt': instance.createdAt.toIso8601String(),
};
