import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static String get publishableKey {
    final key = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('STRIPE_PUBLISHABLE_KEY not found in .env file');
    }
    return key;
  }

  static String get secretKey {
    final key = dotenv.env['STRIPE_SECRET_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('STRIPE_SECRET_KEY not found in .env file');
    }
    return key;
  }

  // Initialize Stripe 
  static Future<void> initialize() async {
    try {
      Stripe.publishableKey = publishableKey;
      await Stripe.instance.applySettings();
      debugPrint('✅ Stripe initialized successfully');
    } catch (e) {
      debugPrint('⚠️ Stripe initialization warning: $e');
    }
  }

  // Create Payment Intent on your backend
  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String orderId,
  }) async {
    try {
      debugPrint('💳 Creating Stripe payment intent...');
      debugPrint('Amount: $currency ${amount.toStringAsFixed(2)}');
      
      // Convert amount to smallest currency unit (paise for INR)
      final amountInSmallestUnit = (amount * 100).toInt();

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInSmallestUnit.toString(),
          'currency': currency.toLowerCase(),
          'metadata[order_id]': orderId,
          'metadata[source]': 'RizqMart',
          'automatic_payment_methods[enabled]': 'true',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Payment intent created: ${data['id']}');
        return {
          'success': true,
          'clientSecret': data['client_secret'],
          'paymentIntentId': data['id'],
        };
      } else {
        debugPrint('❌ Failed to create payment intent: ${response.body}');
        throw Exception('Failed to create payment intent: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error creating payment intent: $e');
      rethrow;
    }
  }

  // Present Payment Sheet
  static Future<bool> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    try {
      debugPrint('🎨 Presenting payment sheet...');
      
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
          style: ThemeMode.system,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: const Color(0xFF4CAF50),
            ),
          ),
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      
      debugPrint('✅ Payment completed successfully');
      return true;
    } on StripeException catch (e) {
      debugPrint('❌ Stripe error: ${e.error.message}');
      if (e.error.code == FailureCode.Canceled) {
        debugPrint('User cancelled the payment');
      }
      return false;
    } catch (e) {
      debugPrint('❌ Payment sheet error: $e');
      return false;
    }
  }

  // Confirm payment (retrieve payment intent)
  static Future<Map<String, dynamic>> confirmPayment(String paymentIntentId) async {
    try {
      debugPrint('🔍 Confirming payment: $paymentIntentId');
      
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
        headers: {
          'Authorization': 'Bearer $secretKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Payment status: ${data['status']}');
        
        return {
          'success': data['status'] == 'succeeded',
          'status': data['status'],
          'amount': data['amount'],
          'currency': data['currency'],
        };
      } else {
        throw Exception('Failed to confirm payment');
      }
    } catch (e) {
      debugPrint('❌ Error confirming payment: $e');
      rethrow;
    }
  }

  // Refund payment
  static Future<bool> refundPayment(String paymentIntentId, {double? amount}) async {
    try {
      debugPrint('🔄 Refunding payment: $paymentIntentId');
      
      final body = {
        'payment_intent': paymentIntentId,
      };
      
      if (amount != null) {
        body['amount'] = (amount * 100).toInt().toString();
      }

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/refunds'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Refund successful');
        return true;
      } else {
        debugPrint('❌ Refund failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Refund error: $e');
      rethrow;
    }
  }
}