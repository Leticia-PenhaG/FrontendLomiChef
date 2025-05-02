import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:lomi_chef_to_go/src/provider/orders_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../../models/order.dart';
import '../../../../models/user.dart';
import '../../../../utils/shared_preferences_helper.dart';

class RestaurantOrdersListController {
  BuildContext? context;
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>(); //para poder desplegar el menu de opciones lateral
  late User user;
  late Function refresh;
  List<String> status = ['Pagado','Listo para envío','En ruta','Entrega completada'];
  OrdersProvider _ordersProvider = new OrdersProvider();

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));
    _ordersProvider.init(context, user);
    refresh();
  }

  void logout() {
    if (context == null) {
      print('Error: El contexto no ha sido inicializado.');
      return;
    }
    _sharedPreferencesHelper.logout(context!, user.id!);
  }

  bool isInitialized() {
    return context != null;
  }

  void openDrawerBar() {
    key.currentState?.openDrawer(); //menu de opciones lateral
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context!, 'roles', (route) => false);
  }

  void goToCategoriesCreate() {
    Navigator.pushNamed( context!, 'restaurant/categories/create');
  }

  void goToProductsCreate() {
    Navigator.pushNamed( context!, 'restaurant/products/create');
  }

  Future<List<Order>> getOrders(String status) async {
    print('Buscando órdenes con status: $status');

    // Normalizar el status
    String formattedStatus = status
        .replaceAll(' ', '_')
        .replaceAll('í', 'i')
        .replaceAll('é', 'e')
        .replaceAll('á', 'a')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .toUpperCase();

    print('Status formateado para backend: $formattedStatus');

    return await _ordersProvider.getByStatus(formattedStatus);
  }

  //se abre este method cuando se presiona el card para ver el detalle de la orden
  void openBottomSheet(Order order) {
    showMaterialModalBottomSheet
      (
        context: context!,
        builder: (context) => RestaurantOrdersDetailPage(order: order)
    );
  }
}
