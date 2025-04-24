
import 'dart:convert';
import 'package:collection/collection.dart';
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

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user'));
    _addressProvider.init(context, user);
    await getAddress();
    refresh();
  }

  Future<List<Address>> getAddress() async {
    address = await _addressProvider.getByUser(user.id!);
    return address;
  }

  Function onAddressSelected(String addressId) {
    return () async {
      print('Iniciando selección de dirección...');

      Address? selectedAddress = address.firstWhereOrNull((a) => a.id == addressId);
      if (selectedAddress == null) {
        print('Dirección con ID $addressId no encontrada');
        return;
      }

      print('Dirección encontrada: ${selectedAddress.toJson()}');

      String addressJson = json.encode(selectedAddress.toJson());
      print('Guardando en SharedPreferences: $addressJson');

      await _sharedPreferencesHelper.saveSessionToken('address', addressJson);

      String? savedJson = await _sharedPreferencesHelper.readSessionToken('address');
      print('Leído de SharedPreferences: $savedJson');

      if (savedJson != null) {
        Address a = Address.fromJson(json.decode(savedJson));
        print('Se guardó la dirección: ${a.toJson()}');
      }

      print('Dirección seleccionada: $addressId');
    };
  }

  void goToNewAddress() async {
    final result = await Navigator.pushNamed(context!, 'client/address/create');
    if (result == true) {
      await getAddress();
      refresh!();
    }
  }

}