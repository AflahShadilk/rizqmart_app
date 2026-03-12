

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// ---------------- Stripe Service ----------------

/// Encapsulates all Stripe payment interactions via the secure Firebase Cloud Functions backend.
/// The Stripe secret key is never used on the client — only the publishable key.
class StripeService {

  // ---------------- Backend Base URL ----------------
  static const String _baseUrl =
      'https://us-central1-rizqmart-486b8.cloudfunctions.net/api';

  // ---------------- Publishable Key ----------------
  static String get publishableKey {
    final key = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('STRIPE_PUBLISHABLE_KEY not found in .env file');
    }
    return key;
  }

  // ---------------- Initialize Stripe SDK ----------------
  static Future<void> initialize() async {
    try {
      Stripe.publishableKey = publishableKey;
      await Stripe.instance.applySettings();
    } catch (_) {}
  }

  // ---------------- Request Payment Intent From Backend ----------------
  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String orderId,
  }) async {
    try {
      final amountInSmallestUnit = (amount * 100).toInt();

      final response = await http.post(
        Uri.parse('$_baseUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amountInSmallestUnit,
          'currency': currency.toLowerCase(),
          'orderId': orderId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'clientSecret': data['clientSecret'],
          'paymentIntentId': data['paymentIntentId'],
          'customerId': data['customerId'],
          'ephemeralKey': data['ephemeralKey'],
        };
      } else {
        throw Exception('Failed to create payment intent: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // ---------------- Initialize & Present Payment Sheet ----------------
  static Future<bool> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
    String? customerId,
    String? ephemeralKey,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
          customerId: customerId,
          customerEphemeralKeySecret: ephemeralKey,
          style: ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: const Color(0xFF4CAF50),
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {}
      return false;
    } catch (e) {
      return false;
    }
  }

  // ---------------- Confirm Payment Via Backend ----------------
  static Future<Map<String, dynamic>> confirmPayment(String paymentIntentId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/confirm-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'paymentIntentId': paymentIntentId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': data['success'] ?? false,
          'status': data['status'],
          'amount': data['amount'],
          'currency': data['currency'],
        };
      } else {
        throw Exception('Failed to confirm payment');
      }
    } catch (e) {
      rethrow;
    }
  }

  // ---------------- Refund Payment Via Backend ----------------
  static Future<bool> refundPayment(String paymentIntentId, {double? amount}) async {
    try {
      final body = <String, dynamic>{'paymentIntentId': paymentIntentId};
      if (amount != null) {
        body['amount'] = (amount * 100).toInt();
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/refund-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  // ---------------- Create Payment Method (Client-Side - Publishable Key) ----------------
  static Future<Map<String, dynamic>> createPaymentMethod({
    required String number,
    required String expMonth,
    required String expYear,
    required String cvc,
  }) async {
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: const BillingDetails(),
          ),
        ),
      );

      return {
        'id': paymentMethod.id,
        'last4': paymentMethod.card.last4,
        'brand': paymentMethod.card.brand,
      };
    } catch (e) {
      rethrow;
    }
  }

  // ---------------- Confirm Payment With Saved Card (Client-Side - Publishable Key) ----------------
  static Future<Map<String, dynamic>> confirmPaymentWithSavedCard({
    required String clientSecret,
    required String paymentMethodId,
  }) async {
    try {
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: PaymentMethodParams.cardFromMethodId(
          paymentMethodData: PaymentMethodDataCardFromMethod(
            paymentMethodId: paymentMethodId,
          ),
        ),
      );

      return {
        'success': paymentIntent.status == PaymentIntentsStatus.Succeeded,
        'status': paymentIntent.status.name,
        'amount': paymentIntent.amount,
        'currency': paymentIntent.currency,
        'paymentIntentId': paymentIntent.id,
      };
    } catch (e) {
      rethrow;
    }
  }
}