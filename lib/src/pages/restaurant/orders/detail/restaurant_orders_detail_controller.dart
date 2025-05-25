
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/models/user.dart';
import 'package:lomi_chef_to_go/src/provider/orders_provider.dart';
import 'package:lomi_chef_to_go/src/provider/push_notifications_provider.dart';
import 'package:lomi_chef_to_go/src/provider/user_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import 'package:lomi_chef_to_go/src/utils/snackbar_helper.dart';
import '../../../../models/product.dart';
import '../../../../models/order.dart';

class RestaurantOrdersDetailController {
  BuildContext? context;
  Function? refresh;
  Product? product;

  //añadir la cantidad del prducto en el share preference
  int counter = 1;
  double productPrice = 0;

  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  List<Product> selectedProducts = [];
  double total = 0;
  Order? order;
  User? user;
  List<User> users = [];
  String? idDelivery;

  UserProvider _userProvider = new UserProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();

  void init(BuildContext context, Function refresh, Order order) async{
    this.context = context;
    this.refresh = refresh;
    this.order = order;

    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user')) ;
    _userProvider.init(context, sessionUser: user);
    _ordersProvider.init(context,  user!);

    var orderData = await _sharedPreferencesHelper.readSessionToken('order') ?? [];
    if (orderData != null) {
      selectedProducts = Product.fromJsonList(orderData).toList;
    } else {
      selectedProducts = [];
    }


    getTotal();
    await getUsers();
    print('REPARTIDORES OBTENIDOS: ${users.length}');
    print('NOMBRES: ${users.map((u) => u.name).toList()}');
    refresh();
  }

  void getTotal(){
    total = 0;
    selectedProducts.forEach((product) {
      if (product.price != null) {
        total = total + (product.quantity! * product.price!);
      }
    });

    refresh!();
  }

  void increaseQuantity(Product product) {
    int index = selectedProducts.indexWhere((prod) => prod.id == product.id);
    selectedProducts[index].quantity = (selectedProducts[index].quantity! + 1);
    _sharedPreferencesHelper.saveSessionToken('order', selectedProducts);
    getTotal();
  }

  void decreaseQuantity(Product product) {
    int index = selectedProducts.indexWhere((prod) => prod.id == product.id);
    if (selectedProducts[index].quantity! > 1) {
      selectedProducts[index].quantity = (selectedProducts[index].quantity! - 1);
      _sharedPreferencesHelper.saveSessionToken('order', selectedProducts);
      getTotal();
    }
  }

  void deleteItem(Product product){
    selectedProducts.removeWhere((p) => p.id == product.id);
    _sharedPreferencesHelper.saveSessionToken('order', selectedProducts);
    getTotal();
  }

  String formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  void goToAddress() {
    Navigator.pushNamed(context!, 'client/address/list');
  }

  Future<void> getUsers() async {
    users = await _userProvider.loadCouriers();
    print('REPARTIDORES OBTENIDOS: ${users.length}');
    print('NOMBRES: ${users.map((e) => e.name).toList()}');
  }

  void updateOrder() async {
    if (idDelivery != null) {
      order?.idDelivery = idDelivery;

      ResponseApi? responseApi = await _ordersProvider.markOrderAsReadyToDeliver(order!);

      // Aseguramos que idDelivery no sea null
      User? deliveryUser = await _userProvider.getUserById(order!.idDelivery!);

      if (deliveryUser != null && deliveryUser.notificationToken != null) {
        print('TOKEN DE NOTIFICACIÓN DEL DELIVERY: ${deliveryUser.notificationToken}');
        sendNotification(deliveryUser.notificationToken!);
      } else {
        print('No se pudo obtener el usuario delivery o no tiene token de notificación.');
      }

      if (responseApi != null) {
        Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context!, true);
      } else {
        Fluttertoast.showToast(msg: 'Error al actualizar la orden');
      }

    } else {
      Fluttertoast.showToast(msg: 'Seleccioná un repartidor');
    }
  }

  void sendNotification(String tokenDelivery) {
    if (tokenDelivery.isEmpty) {
      print('Token de notificación vacío, se omite el envío');
      return;
    }

    pushNotificationsProvider.sendMessageFCMV1(
      fcmToken: tokenDelivery,
      title: 'Pedido asignado',
      body: 'Se te asignó un nuevo pedido',
      data: {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK'//,
        //'type': 'pedido_asignado',
      },
    );
  }
}
