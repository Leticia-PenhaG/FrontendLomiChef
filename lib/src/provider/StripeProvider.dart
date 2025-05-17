import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:lomi_chef_to_go/src/utils/snackbar_helper.dart';
import '../models/stripe_transactions_response.dart';

/*class StripeProvider {
  // String secret =
  //     'sk_test_51RNO98QiPvfAEWukK4lWbRcv6s0Gh2OgdD0n8lQBhPx3EKJD7SbVqRJ3RZ0AsftuJ4QYNziJtdBpzf1DTrOsd0dS00Amsdiiqf';
  // Map<String, String> headers = {
  //   'Authorization':
  //       'Bearer sk_test_51RNO98QiPvfAEWukK4lWbRcv6s0Gh2OgdD0n8lQBhPx3EKJD7SbVqRJ3RZ0AsftuJ4QYNziJtdBpzf1DTrOsd0dS00Amsdiiqf',
  //   'Content-type': 'application/x-www-form-urlencoded'
  // };
  late final BuildContext context;


  // void init(BuildContext context) {
  //   this.context = context;
  //   StripePayment.setOptions(StripeOptions(
  //     publishableKey: 'pk_test_51RNO98QiPvfAEWukdYLmw408HaX0kXH3uardBuyHNDxJ2hR9eY8qlQ5yDe3bs0kilNxbQya8Iu3JUFuYitHHy1VF00jeLLR6y7',
  //     merchantId:'test',
  //     androidPayMode: 'test'
  //   ));
  // }

  void init(BuildContext context) {
    this.context = context;
    Stripe.publishableKey = 'pk_test_51RNO98QiPvfAEWukdYLmw408HaX0kXH3uardBuyHNDxJ2hR9eY8qlQ5yDe3bs0kilNxbQya8Iu3JUFuYitHHy1VF00jeLLR6y7';
    Stripe.merchantIdentifier = 'merchant.com.LomiChef';
    Stripe.urlScheme = 'flutterstripe'; // opcional
    Stripe.instance.applySettings();
  }

  Future<StripeTransactionsResponse?> payWithCard(String amount, String currency) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(CardFormePaymentRequest());
      var paymentIntent = await createPaymentIntent(amount, currency);
      var response = await StripePayment.confirmedPaymentIntent(PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id
      ));

      if(response.status = 'succeeded') {
        return new StripeTransactionsResponse(
            message:'Transacción exitosa',
            success: true
        );
      } else {
        return new StripeTransactionsResponse(
            message:'Transacción fallida',
            success: false
        );
      }
    } catch(e) {
      print('Ocurrió un error al realizar la transacción $e');
      SnackbarHelper.show(
        context: context,
        message: 'Ocurrió un error al realizar la transacción $e',
        isError: true,
      );
      return null;
    }
  }

  Future<Map<String,dynamic>?> createPaymentIntent(String amount, String currency) async{
    try {
      Map<String, dynamic> body = {
        'amount':amount,
        'currency':currency,
        'paymentMethodTypes[card]':'card'
      };

      Uri uri = Uri.https('api.stripe.com', 'v1/payments_intents');
      var response = await http.post(uri, body: body, headers: headers);
      return jsonDecode(response.body);
    } catch(e) {
      print('Ocurrió un error al crear el intent de pagos $e');
      return null;
    }
  }

}*/

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:lomi_chef_to_go/src/utils/snackbar_helper.dart';
import '../models/stripe_transactions_response.dart';

class StripeProvider {
  late final BuildContext context;

  final String secretKey = 'sk_test_51RNO98QiPvfAEWukLiTVX3uLB8mEtN094nL1zi9JJepRZREsZ2Pi9lPUuAtiI7ZcuYzutsjFs88julp5HJoFlGI7003pRpEOPU'; // ¡No compartas esto públicamente!
  final String publishableKey = 'pk_test_51RNO98QiPvfAEWukxFVYjilehGCmMt0zuEl71YtBFHYrlpKzgCSxViTmF1XR79guYEBqIfK1n5BXsWNL8FzyeMIp00RGXNfwmm';

  void init(BuildContext context) {
    this.context = context;

    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = 'merchant.com.LomiChef';
    Stripe.urlScheme = 'flutterstripe'; // opcional
    Stripe.instance.applySettings();
  }

  Future<StripeTransactionsResponse?> payWithCard(String amount, String currency) async {
    try {
      // Crear intent de pago
      final paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData == null) return null;

      // Confirmar el method de pago
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: 'Lomi Chef',
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return StripeTransactionsResponse(
        message: 'Transacción exitosa',
        success: true,
      );
    } catch (e) {
      print('Error en el pago: $e');

      SnackbarHelper.show(
        context: context,
        message: 'Ocurrió un error al realizar el pago: $e',
        isError: true,
      );

      return StripeTransactionsResponse(
        message: 'Error: $e',
        success: false,
      );
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      final body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      print('Error al crear PaymentIntent: $e');
      return null;
    }
  }
}
