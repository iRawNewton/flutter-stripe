import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:flutter_stripe_pay/pt_intent.dart';
import 'package:logger/logger.dart';

class FlutterStripe extends StatefulWidget {
  const FlutterStripe({super.key});

  @override
  State<FlutterStripe> createState() => _FlutterStripeState();
}

class _FlutterStripeState extends State<FlutterStripe> {
  Map<String, dynamic>? paymentIntent;
  final TextEditingController success = TextEditingController();
  final TextEditingController error = TextEditingController();
  final TextEditingController unk = TextEditingController();
  final logger = Logger();

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('10', 'USD');
      if (paymentIntent == null) {
        // Handle the case where the payment intent wasn't created successfully.
        return;
      }

      // STEP 2: Initialize payment sheet
      final result = await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret:
              paymentIntent!['client_secret'], // Gotten from payment intent
          style: ThemeMode.light,
          merchantDisplayName: 'Kyptronix LLP',
          googlePay: gpay,
        ),
      );

      // logger.d(result);
      if (result != null) {
        debugPrint(result as String?);
        // Handle initialization error.
        return;
      }

      // STEP 3: Display payment sheet
      displayPaymentSheet();
    } catch (e) {
      //   // Handle any other unexpected errors.
      debugPrint('Error: $e');
    }
  }

  var gpay = const PaymentSheetGooglePay(
      merchantCountryCode: "GB", currencyCode: "GBP", testEnv: true);

  displayPaymentSheet() async {
    final paymentResult = await Stripe.instance
        .presentPaymentSheet(options: const PaymentSheetPresentOptions());
    // state = NetworkState.success;
    setState(() {
      unk.text = paymentResult.toString();
    });
    if (paymentResult != null) {
      // Handle any payment sheet errors.
      debugPrint('Payment Sheet Error: $paymentResult');
      setState(() {
        error.text = paymentResult.toString();
      });
    } else {
      // Payment was successful.
      setState(() {
        success.text = paymentResult.toString();
      });
      debugPrint('Payment successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('success'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: success,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
            ),
            const Text('error'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: error,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
            ),
            const Text('unk'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: unk,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.9,
          child: ElevatedButton(
            onPressed: () {
              makePayment();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.black), // Change the background color to green
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Change the border radius to 12.0
                ),
              ),
            ),
            child: const Text(
              'Pay Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //           context: context,
  //           builder: (_) => const AlertDialog(
  //                 content: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Icon(
  //                       Icons.check_circle,
  //                       color: Colors.green,
  //                       size: 100.0,
  //                     ),
  //                     SizedBox(height: 10.0),
  //                     Text("Payment Successful!"),
  //                   ],
  //                 ),
  //               ));

  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       throw Exception(error);
  //     });
  //   } on StripeException catch (e) {
  //     print('Error is:---> $e');
  //     const AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(
  //                 Icons.cancel,
  //                 color: Colors.red,
  //               ),
  //               Text("Payment Failed"),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   } catch (e) {
  //     print('$e');
  //   }
  // }
}
