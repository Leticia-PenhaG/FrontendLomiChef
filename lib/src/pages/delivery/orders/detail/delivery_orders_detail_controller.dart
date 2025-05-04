
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/models/user.dart';
import 'package:lomi_chef_to_go/src/provider/orders_provider.dart';
import 'package:lomi_chef_to_go/src/provider/user_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import 'package:lomi_chef_to_go/src/utils/snackbar_helper.dart';
import '../../../../models/product.dart';
import '../../../../models/order.dart';

class DeliveryOrdersDetailController {
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

  void init(BuildContext context, Function refresh, Order order) async{
    this.context = context;
    this.refresh = refresh;
    this.order = order;

    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));
    _userProvider.init(context, sessionUser: user);
    _ordersProvider.init(context,  user!);

    selectedProducts = Product.fromJsonList(await _sharedPreferencesHelper.readSessionToken('order')).toList; //trae del sharepreference la orden    //PARA CONTROLAR QUÉ PRODUCTOS YA FUERON AÑADIDOS Y NO PERDER LA LISTA AL AGREGAR NUEVOS PRODUCTOS

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

  void updateOrderStatus() async { //CAMBIAR DE ESTADO A 'EN RUTA'
    if(order?.status == 'LISTO_PARA_ENVIO') {
      ResponseApi? responseApi = await _ordersProvider.updateOrderToOnTheWay(order!);
      if (responseApi != null) {
        //SnackbarHelper.show(context: context!, message: responseApi.message);
        Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
        Navigator.pop(context!, true); //para visualizar cambios inmediatos en el frontend cuando se actualiza el estado de la orden

        if(responseApi.success) {
          Navigator.pushNamed(context!, 'delivery/orders/map', arguments: order?.toJson()); //SE ENVÍA A LA PANTALLA DEL MAPA
        }

      } else {
        Fluttertoast.showToast(msg: 'Error al actualizar la orden');
      }
    } else {
      Navigator.pushNamed(context!, 'delivery/orders/map', arguments: order?.toJson()); //SE ENVÍA A LA PANTALLA DEL MAPA
    }
  }

}
