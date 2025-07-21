import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:candidate_website/src/config.dart';

class StripeService {
  static Future<String?> createCheckoutSession(
      String amount, String publicKey) async {
    final url = Uri.parse('$apiBaseUrl/donate/create-checkout-session');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': amount,
        'publicKey': publicKey,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['sessionId'];
    } else {
      return null;
    }
  }
}
