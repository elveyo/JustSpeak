import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final int id;
  final double amount;
  final String status;
  String sender;
  String recipient;
  final DateTime createdAt;

  Payment({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.sender = '',
    this.recipient = '',
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
