
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lomi_chef_to_go/src/models/Address.dart' as my_address;
import 'package:lomi_chef_to_go/src/models/order.dart';
import 'package:lomi_chef_to_go/src/models/product.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/provider/StripeProvider.dart';
import 'package:lomi_chef_to_go/src/provider/address_provider.dart';
import 'package:lomi_chef_to_go/src/provider/orders_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../../../../keys.dart';
import '../../../../../main.dart';
import '../../../../models/user.dart';
import '../../../../provider/push_notifications_provider.dart';
import '../../../../provider/user_provider.dart';
import '../../../../utils/snackbar_helper.dart';

class ClientAddressListController {

  BuildContext? context;
  Function? refresh;
  String? selectedAddressId;
  List<my_address.Address> address = [];
  double _total = 0;
  double get total => _total;

  AddressProvider _addressProvider = new AddressProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  StripeProvider _stripeProvider = new StripeProvider();
  UserProvider _userProvider = new UserProvider();
  late User user;
  SharedPreferencesHelper _sharedPreferencesHelper = new SharedPreferencesHelper();
  late ProgressDialog _progressDialog;
  List<String> tokens = [];


  Future init(BuildContext context, Function refresh, double total) async {
    this.context = context;
    this.refresh = refresh;
    this._total = total;
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));

    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);
    _stripeProvider.init(context);
    _progressDialog = ProgressDialog(context: context);


    await getAddress();
    await loadSelectedAddress();

    print('Dirección seleccionada al iniciar: $selectedAddressId');

    refresh();
  }

  /// Obtiene las direcciones asociadas al usuario desde el provider
  Future<List<my_address.Address>> getAddress() async {
    address = await _addressProvider.getByUser(user.id!);
    return address;
  }

  /// Retorna una función para seleccionar una dirección y guardarla en preferencias
  Function onAddressSelected(String addressId) {
    return () async {
      my_address.Address? selectedAddress = address.firstWhereOrNull((a) => a.id == addressId);
      if (selectedAddress == null) return;

      await _sharedPreferencesHelper.saveSessionToken('address', selectedAddress.toJson());
      selectedAddressId = selectedAddress.id;
      refresh!();
    };
  }

  /// Navega a la pantalla para agregar una nueva dirección y recarga los datos si se agregó con éxito
  void goToNewAddress() async {
    final result = await Navigator.pushNamed(context!, 'client/address/create');
    if (result == true) {
      await getAddress();
      await loadSelectedAddress();
      refresh!();
    }
  }

  /// Carga la dirección seleccionada previamente desde las preferencias
  Future<void> loadSelectedAddress() async {
    dynamic saved = await _sharedPreferencesHelper.readSessionToken('address');
    if (saved != null && saved is Map<String, dynamic>) {
      my_address.Address a = my_address.Address.fromJson(saved);
      selectedAddressId = a.id;
    }
  }

  /// Crea una orden después de procesar el pago con Stripe
  void createOrder() async {
    _progressDialog.show(max: 100, msg: 'Esperá un momento');

    my_address.Address a = my_address.Address.fromJson(await _sharedPreferencesHelper.readSessionToken('address'));
    List<Product> selectedProducts = Product.fromJsonList(await _sharedPreferencesHelper.readSessionToken('order')).toList;

    Order order = Order(
      id: '',
      idDelivery: '',
      idClient: user.id!,
      idAddress: a.id!,
      status: 'CREATED',
      products: selectedProducts,
      lat: 0.0,
      lng: 0.0,
      timeStamp: DateTime.now().millisecondsSinceEpoch,
    );

    ResponseApi? responseApi = await _ordersProvider.createOrder(order);

    _progressDialog.close();

    if (responseApi?.success == true) {
      Fluttertoast.showToast(msg: 'ORDEN CREADA CORRECTAMENTE');
      //Navigator.pushNamed(context!, 'client/payments/create');

      //SI SE CREÓ LA ORDEN CORRECTAMENTE, SE LE REDIRIGE A LA PÁGINA DE PEDIDO EXITOSO Y SE ENVÍA LA NOTIFICACIÓN
      _userProvider.init(context!,sessionUser: user);
      tokens = await _userProvider.getAdminsNotificationTokens();
      print('TOKENS PARA NOTIFICACIÓN: $tokens');

      sendNotification();

      Navigator.pushNamed(context!, 'client/payments/successful_page');
      print('Respuesta orden: ${responseApi?.message}');
    } else {
      SnackbarHelper.show(
        context: context!,
        message: responseApi?.message ?? 'Error al crear la orden',
        isError: true,
      );
      // Redirigir a la pantalla de error
      Navigator.pushNamed(context!, 'client/payments/error_page');
    }
  }

  Map<String, dynamic>? _intentPaymentData;

  /// Inicializa Stripe Payment Sheet con los parámetros necesarios
  Future<void> paymentSheetInitialization(String amountToBeCharged, String currency) async {
    try {
      _intentPaymentData = await _createPaymentIntent(amountToBeCharged, currency);

      if (_intentPaymentData == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: _intentPaymentData!['client_secret'],
          style: ThemeMode.light,
          merchantDisplayName: "Lomi Chef",
          allowsDelayedPaymentMethods: true,
        ),
      );

      _displayPaymentSheet();

    } catch (e, s) {
      print("Error al inicializar PaymentSheet: $e");
      print("Stacktrace: $s");
    }
  }

  /// Muestra la Payment Sheet de Stripe y crea una orden si el pago fue exitoso
  Future<void> _displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      _intentPaymentData = null;

      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(content: Text("Pago realizado con éxito!")),
      );

      createOrder(); // como ya se pagó el pedido, se crea la orden

    } on StripeException catch (e) {
      print("Pago cancelado: $e");
      showDialog(
        context: context!,
        builder: (_) => const AlertDialog(
          content: Text("El pago fue cancelado."),
        ),
      );
      Navigator.pushNamed(context!, 'client/payments/error_page');
    } catch (e, s) {
      print("Error al mostrar PaymentSheet: $e\n$s");
    }
  }

  String getErrorMessageFromStripe(String? code, String? declineCode) {
    if (code == 'card_declined') {
      switch (declineCode) {
        case 'insufficient_funds':
          return 'Tu tarjeta no cuenta con fondos suficientes. Probá con otra tarjeta o medio de pago.';
        case 'lost_card':
          return 'La tarjeta fue reportada como extraviada. Intentá con otro medio de pago.';
        case 'stolen_card':
          return 'La tarjeta fue reportada como robada. No se puede procesar el pago.';
        case 'card_velocity_exceeded':
          return 'Se superó el límite de intentos con esta tarjeta. Esperá un momento e intentá más tarde.';
        case 'generic_decline':
        default:
          return 'Tu tarjeta fue rechazada. Verificá los datos o intentá con otro medio de pago.';
      }
    }

    switch (code) {
      case 'expired_card':
        return 'Tu tarjeta ha expirado. Verificá la fecha de vencimiento o utilizá una tarjeta válida.';
      case 'incorrect_cvc':
        return 'El código de seguridad (CVC) es incorrecto. Asegurate de ingresar los tres dígitos del reverso de tu tarjeta.';
      case 'processing_error':
        return 'Hubo un error de procesamiento inesperado. Intentá nuevamente más tarde o utilizá otro método de pago.';
      case 'incorrect_number':
        return 'El número de tarjeta es incorrecto. Verificá e ingresá nuevamente.';
      default:
        return 'Ocurrió un error al procesar tu pago. Por favor, revisá los datos e intentá nuevamente.';
    }
  }

  /// Crea un intent de pago en Stripe y retorna los datos del intent
  Future<Map<String, dynamic>?> _createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        //'amount': (int.parse(amount) * 100).toString(), //USD
        'amount': amount,
        'currency': currency, // "PYG"
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      return jsonDecode(response.body);

    } catch (e) {
      print("Error al crear PaymentIntent: $e");
      return null;
    }
  }

  void sendNotification() {

    List<String> registration_ids = [];

    tokens.forEach((token) {
      if (token != null) {
        registration_ids.add(token);
      }
    });

    pushNotificationsProvider.sendMessageFCMV1MultipleUsers(
      fcmTokenList: registration_ids,
      title: 'COMPRA EXITOSA',
      body: 'Un cliente realizó un pedido',
      data: {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK'//,
        //'type': 'pedido_asignado',
      },
    );
  }
}