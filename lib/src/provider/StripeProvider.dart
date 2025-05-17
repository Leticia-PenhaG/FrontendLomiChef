import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:lomi_chef_to_go/src/utils/snackbar_helper.dart';
import '../models/stripe_transactions_response.dart';

class StripeProvider {
  late final BuildContext context;

  final String secretKey =
      'sk_test_51RNO98QiPvfAEWukLiTVX3uLB8mEtN094nL1zi9JJepRZREsZ2Pi9lPUuAtiI7ZcuYzutsjFs88julp5HJoFlGI7003pRpEOPU'; // ¡No compartas esto públicamente!
  final String publishableKey =
      'pk_test_51RNO98QiPvfAEWukxFVYjilehGCmMt0zuEl71YtBFHYrlpKzgCSxViTmF1XR79guYEBqIfK1n5BXsWNL8FzyeMIp00RGXNfwmm';

  /// Inicializa la configuración necesaria para utilizar Stripe en la aplicación,
  /// incluyendo claves, identificador de comerciante y esquema de URL.
  void init(BuildContext context) {
    this.context = context;

    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = 'merchant.com.LomiChef';
    Stripe.urlScheme = 'flutterstripe'; // opcional
    Stripe.instance.applySettings();
  }

  /// Ejecuta el flujo de pago con tarjeta usando Stripe Payment Sheet.
  /// Crea el PaymentIntent, inicializa y muestra la hoja de pago.
  /// Devuelve un objeto que indica si el pago fue exitoso o no.
  Future<StripeTransactionsResponse?> payWithCard(
      String amount, String currency) async {
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

  /// Crea un PaymentIntent usando la API de Stripe con el monto y moneda proporcionados.
  /// Devuelve los datos del intent en caso de éxito, o null si ocurre un error.
  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency) async {
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
