


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Encapsulates all Stripe payment interactions, from creating intents to refunding orders.
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

  
  static Future<void> initialize() async {
    try {
      Stripe.publishableKey = publishableKey;
      await Stripe.instance.applySettings();

    
    } catch (_) {
    }
  }

  
  static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String orderId,
  }) async {
    try {

      
      
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

        return {
          'success': true,
          'clientSecret': data['client_secret'],
          'paymentIntentId': data['id'],
        };
      } else {

        throw Exception('Failed to create payment intent: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  
  static Future<bool> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    try {

      
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
      

      return true;
    } on StripeException catch (e) {

      if (e.error.code == FailureCode.Canceled) {

      }
      return false;
    } catch (e) {

      return false;
    }
  }

  
  static Future<Map<String, dynamic>> confirmPayment(String paymentIntentId) async {
    try {

      
      final response = await http.get(
        Uri.parse('https://api.stripe.com/v1/payment_intents/$paymentIntentId'),
        headers: {
          'Authorization': 'Bearer $secretKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        
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

      rethrow;
    }
  }

  
  static Future<bool> refundPayment(String paymentIntentId, {double? amount}) async {
    try {

      
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

        return true;
      } else {

        return false;
      }
    } catch (e) {

      rethrow;
    }
  }
  
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