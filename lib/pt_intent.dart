import 'dart:convert';

// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> createPaymentIntent(
    String amount, String currency) async {
  final Map<String, String> body = {
    'amount': amount,
    'currency': currency,
  };

  const String secretKey =
      'sk_test_51O282JSDBMiD0KSwixS8TfPhqVu9zqCnLGGanG8v6AYs7QtiNiXiFwgKkNW6NePE71TCDkxCMyzz84YKijSgHXRg00SwIfG17y'; // Replace with your actual Stripe Secret Key

  final response = await http.post(
    Uri.parse('https://api.stripe.com/v1/payment_intents'),
    headers: {
      'Authorization': 'Bearer $secretKey',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: body,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    return responseData;
  } else {
    throw Exception('Failed to create payment intent');
  }
}

// createPaymentIntent(String amount, String currency) async {
//   try {
//     //Request body
//     Map<String, dynamic> body = {
//       'amount': amount,
//       'currency': currency,
//     };

//     //Make post request to Stripe
//     var response = await http.post(
//       Uri.parse('https://api.stripe.com/v1/payment_intents'),
//       headers: {
//         'Authorization':
//             'Bearer sk_test_51O282JSDBMiD0KSwixS8TfPhqVu9zqCnLGGanG8v6AYs7QtiNiXiFwgKkNW6NePE71TCDkxCMyzz84YKijSgHXRg00SwIfG17y',
//         'Content-Type': 'application/x-www-form-urlencoded'
//       },
//       body: body,
//     );
//     return json.decode(response.body);
//   } catch (err) {
//     throw Exception(err.toString());
//   }
// }
