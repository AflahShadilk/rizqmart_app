

import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
class StripeService {
static const String _baseUrl =
      'https://us-central1-rizqmart-486b8.cloudfunctions.net/api';
// This is a PUBLIC key (safe to embed). Used only if .env fails to load in release builds.
  static const String _fallbackPublishableKey =
      'pk_test_51SIDQuE3nm7TXKvpfH5volLRuyiQaAqZuTBsKdMI0cT7WXfUCs40Cj4CkdEikVsdSNHUGAZvDOFYXETJeA6tqfCb00RW9qfWIc';
static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;
static String get publishableKey {
    final key = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
    if (key != null && key.isNotEmpty) {
      return key;
    }
    developer.log(
      'STRIPE_PUBLISHABLE_KEY not found in .env, using fallback key',
      name: 'StripeService',
    );
    return _fallbackPublishableKey;
  }
static Future<void> initialize() async {
    try {
      final key = publishableKey;
      developer.log('Initializing Stripe with key: ${key.substring(0, 12)}...', name: 'StripeService');
      Stripe.publishableKey = key;
      await Stripe.instance.applySettings();
      _isInitialized = true;
      developer.log('Stripe SDK initialized successfully', name: 'StripeService');
    } catch (e, stack) {
      _isInitialized = false;
      developer.log(
        'CRITICAL: Stripe initialization failed: $e',
        name: 'StripeService',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }
static Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    required String orderId,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe SDK is not initialized. Cannot create payment intent.');
      }

      final amountInSmallestUnit = (amount * 100).toInt();

      developer.log(
        'Creating payment intent: amount=$amountInSmallestUnit, currency=$currency, orderId=$orderId',
        name: 'StripeService',
      );

      final response = await http.post(
        Uri.parse('$_baseUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amountInSmallestUnit,
          'currency': currency.toLowerCase(),
          'orderId': orderId,
        }),
      );

      developer.log(
        'Payment intent response: statusCode=${response.statusCode}',
        name: 'StripeService',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['clientSecret'] == null || (data['clientSecret'] as String).isEmpty) {
          throw Exception('Backend returned empty clientSecret');
        }
        return {
          'success': true,
          'clientSecret': data['clientSecret'],
          'paymentIntentId': data['paymentIntentId'],
          'customerId': data['customerId'],
          'ephemeralKey': data['ephemeralKey'],
        };
      } else {
        final errorBody = response.body;
        developer.log(
          'Payment intent failed: statusCode=${response.statusCode}, body=$errorBody',
          name: 'StripeService',
        );
        throw Exception('Failed to create payment intent: ${response.statusCode} - $errorBody');
      }
    } catch (e) {
      developer.log('createPaymentIntent error: $e', name: 'StripeService');
      rethrow;
    }
  }
static Future<bool> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
    String? customerId,
    String? ephemeralKey,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Stripe SDK is not initialized. Cannot present payment sheet.');
      }

      developer.log('Initializing payment sheet...', name: 'StripeService');

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

      developer.log('Payment sheet initialized, presenting...', name: 'StripeService');
      await Stripe.instance.presentPaymentSheet();
      developer.log('Payment sheet completed successfully', name: 'StripeService');

      return true;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        developer.log('Payment cancelled by user', name: 'StripeService');
        throw Exception('Payment cancelled by the user.');
      }
      developer.log(
        'StripeException: code=${e.error.code}, message=${e.error.message}',
        name: 'StripeService',
      );
      throw Exception('Stripe payment failed: ${e.error.localizedMessage ?? e.error.message ?? 'Unknown Stripe error'}');
    } catch (e) {
      developer.log('presentPaymentSheet unexpected error: $e', name: 'StripeService');
      rethrow;
    }
  }
static Future<Map<String, dynamic>> confirmPayment(String paymentIntentId) async {
    try {
      developer.log('Confirming payment: $paymentIntentId', name: 'StripeService');

      final response = await http.post(
        Uri.parse('$_baseUrl/confirm-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'paymentIntentId': paymentIntentId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        developer.log(
          'Payment confirmed: success=${data['success']}, status=${data['status']}',
          name: 'StripeService',
        );
        return {
          'success': data['success'] ?? false,
          'status': data['status'],
          'amount': data['amount'],
          'currency': data['currency'],
        };
      } else {
        developer.log(
          'Confirm payment failed: statusCode=${response.statusCode}, body=${response.body}',
          name: 'StripeService',
        );
        throw Exception('Failed to confirm payment: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('confirmPayment error: $e', name: 'StripeService');
      rethrow;
    }
  }
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
        developer.log(
          'Refund failed: statusCode=${response.statusCode}, body=${response.body}',
          name: 'StripeService',
        );
        return false;
      }
    } catch (e) {
      developer.log('refundPayment error: $e', name: 'StripeService');
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
      developer.log('createPaymentMethod error: $e', name: 'StripeService');
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
      developer.log('confirmPaymentWithSavedCard error: $e', name: 'StripeService');
      rethrow;
    }
  }
}