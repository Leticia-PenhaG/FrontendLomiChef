
import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/models/Address.dart';
import 'package:lomi_chef_to_go/src/provider/address_provider.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';

import '../../../../models/user.dart';

class ClientAddressListController {

  BuildContext? context;
  Function? refresh;

  List<Address> address = [];
  AddressProvider _addressProvider = new AddressProvider();
  late User user;
  SharedPreferencesHelper _sharedPreferencesHelper = new SharedPreferencesHelper();

  /*Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));

    _addressProvider.init(context, user);
  }*/

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));
    _addressProvider.init(context, user);
    await getAddress(); // <-- Cargar aquí
    refresh();          // <-- Llamar refresh después
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser(user.id!);
    return address;
  }

  Function onAddressSelected(String addressId) {
    return () {
      // Guardar dirección seleccionada y redirigir si hace falta
      print('Dirección seleccionada: $addressId');
    };
  }

  void goToNewAddress() {
    Navigator.pushNamed(context!, 'client/address/create');
  }

}