import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PayPalService {
  static final String _clientId = dotenv.env['PAYPAL_CLIENT_ID'] ?? '';
  static final String _clientSecret = dotenv.env['PAYPAL_CLIENT_SECRET'] ?? '';
  static final String _baseUrl = dotenv.env['PAYPAL_MODE'] == 'sandbox'
      ? 'https://api.sandbox.paypal.com'
      : 'https://api.paypal.com';//work when production level

  Future<String?> getAccessToken() async {
    try {
      final auth = base64Encode(utf8.encode('$_clientId:$_clientSecret'));
      final response = await http.post(
        Uri.parse('$_baseUrl/v1/oauth2/token'),
        headers: {
          'Authorization': 'Basic $auth',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['access_token'];
      }
      throw Exception('Failed to get access token: ${response.statusCode}');
    } catch (e) {
      throw Exception('PayPal auth error: $e');
    }
  }

  Future<Map<String, dynamic>> createPayPalOrder({
    required double amount,
    required String orderId,
    required String description,
    required String returnUrl,
    required String cancelUrl,
  }) async {
    try {
      final token = await getAccessToken();
      if (token == null) throw Exception('Unable to authenticate with PayPal');

      final response = await http.post(
        Uri.parse('$_baseUrl/v1/checkout/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'intent': 'CAPTURE',
          'purchase_units': [
            {
              'reference_id': orderId,
              'amount': {
                'currency_code': 'USD',
                'value': amount.toStringAsFixed(2),
              },
              'description': description,
            }
          ],
          'application_context': {
            'return_url': returnUrl,
            'cancel_url': cancelUrl,
            'brand_name': 'RizqMart',
            'user_action': 'PAY_NOW',
          }
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'orderId': data['id'],
          'status': data['status'],
          'links': data['links'],
        };
      }
      throw Exception('Failed to create PayPal order: ${response.statusCode}');
    } catch (e) {
      throw Exception('PayPal order creation error: $e');
    }
  }

  Future<Map<String, dynamic>> capturePayment(String paypalOrderId) async {
    try {
      final token = await getAccessToken();
      if (token == null) throw Exception('Unable to authenticate with PayPal');

      final response = await http.post(
        Uri.parse('$_baseUrl/v1/checkout/orders/$paypalOrderId/capture'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'status': data['status'],
          'transactionId': data['id'],
          'payerEmail': data['payer']?['email_address'],
          'amount': data['purchase_units']?[0]?['payments']?['captures']?[0]?['amount']?['value'],
        };
      }
      throw Exception('Failed to capture payment: ${response.statusCode}');
    } catch (e) {
      throw Exception('PayPal capture error: $e');
    }
  }

  Future<bool> refundPayment(String captureId, {double? amount}) async {
    try {
      final token = await getAccessToken();
      if (token == null) throw Exception('Unable to authenticate with PayPal');

      final body = <String, dynamic>{};
      if (amount != null) {
        body['amount'] = {
          'currency_code': 'USD',
          'value': amount.toStringAsFixed(2),
        };
      }

      final response = await http.post(
        Uri.parse('$_baseUrl/v1/payments/captures/$captureId/refund'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body.isNotEmpty ? jsonEncode(body) : null,
      );

      return response.statusCode == 201;
    } catch (e) {
      throw Exception('PayPal refund error: $e');
    }
  }
}
