import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';
import '../models/user.dart';


/*
class RolesController {
  late BuildContext context;
  late User user;
  SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  Future init(BuildContext context) async {
    this.context = context;
    //se obtine el usuario de sesión
    user = User.fromJson(await sharedPreferencesHelper.readSessionToken('user'));

  }


}*/

class RolesController {
  late BuildContext context;
  //User user = User(); // Se inicializa para evitar errores nulos
  late User user;
  final SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();

  Future<void> init(BuildContext context) async {
    this.context = context;
    // Se obtiene el usuario almacenado en SharedPreferences
    Map<String, dynamic>? userData = await sharedPreferencesHelper.readSessionToken('user');
    if (userData != null) {
      user = User.fromJson(userData);
    }
  }
}
