
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/models/Address.dart';
import 'package:lomi_chef_to_go/src/models/product.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import 'package:lomi_chef_to_go/src/provider/address_provider.dart';
import 'package:lomi_chef_to_go/src/provider/orders_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import '../../../../models/user.dart';
import 'package:lomi_chef_to_go/src/models/order.dart';

class ClientAddressListController {

  BuildContext? context;
  Function? refresh;
  String? selectedAddressId;
  List<Address> address = [];

  AddressProvider _addressProvider = new AddressProvider();
  OrdersProvider _ordersProvider = new OrdersProvider();
  late User user;
  SharedPreferencesHelper _sharedPreferencesHelper = new SharedPreferencesHelper();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));

    _addressProvider.init(context, user);
    _ordersProvider.init(context, user);

    await getAddress();
    await loadSelectedAddress();

    print('Dirección seleccionada al iniciar: $selectedAddressId');

    refresh();
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser(user.id!);
    return address;
  }

  Function onAddressSelected(String addressId) {
    return () async {
      Address? selectedAddress = address.firstWhereOrNull((a) => a.id == addressId);
      if (selectedAddress == null) return;

      await _sharedPreferencesHelper.saveSessionToken('address', selectedAddress.toJson());
      selectedAddressId = selectedAddress.id;
      refresh!();
    };
  }

  void goToNewAddress() async {
    final result = await Navigator.pushNamed(context!, 'client/address/create');
    if (result == true) {
      await getAddress();
      await loadSelectedAddress();
      refresh!();
    }
  }

  Future<void> loadSelectedAddress() async {
    dynamic saved = await _sharedPreferencesHelper.readSessionToken('address');
    if (saved != null && saved is Map<String, dynamic>) {
      Address a = Address.fromJson(saved);
      selectedAddressId = a.id;
    }
  }

  void createOrder() async {
    Address a = Address.fromJson(await _sharedPreferencesHelper.readSessionToken('address')); //las direcciones obtenidas desde sharedpreference
    List<Product> selectedProducts = Product.fromJsonList(await _sharedPreferencesHelper.readSessionToken('order')).toList; //trae del sharepreference la orden    //PARA CONTROLAR QUÉ PRODUCTOS YA FUERON AÑADIDOS Y NO PERDER LA LISTA AL AGREGAR NUEVOS PRODUCTOS

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

    print('Respuesta orden: ${responseApi?.message}');

    // if(responseApi!.success) {
    //
    // }
  }

}