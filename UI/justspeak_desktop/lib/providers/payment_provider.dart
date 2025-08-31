import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:justspeak_desktop/models/payment.dart';
import 'package:justspeak_desktop/providers/base_provider.dart';

class PaymentProvider extends BaseProvider<Payment> {
  PaymentProvider() : super("Payment");

  @override
  Payment fromJson(data) {
    return Payment.fromJson(data);
  }

  Future<void> markPaymentSucceded(int id) async {}

  Future<PaymentResult> payWithPaymentSheet(int amount) async {
    String? stripeTransactionId;

    try {
      Uri uri = buildUri("/create-intent");
      var headers = createHeaders();
      var body = jsonEncode({"amount": amount});
      var response = await http.post(uri, headers: headers, body: body);
      if (response.statusCode != 200) {
        return PaymentResult(
          success: false,
          errorMessage: 'Failed to create PaymentIntent',
        );
      }

      final data = jsonDecode(response.body);
      final clientSecret = data['clientSecret'];
      stripeTransactionId = data['stripeTransactionId'];

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'JustSpeak',
          style: ThemeMode.system,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return PaymentResult(
        success: true,
        stripeTransactionId: stripeTransactionId,
      );
    } catch (e) {
      print("Payment failed: $e");
      return PaymentResult(
        success: false,
        stripeTransactionId: stripeTransactionId,
        errorMessage: e.toString(),
      );
    }
  }
}

class PaymentResult {
  final bool success;
  final String? stripeTransactionId;
  final String? errorMessage;

  PaymentResult({
    required this.success,
    this.stripeTransactionId,
    this.errorMessage,
  });
}
