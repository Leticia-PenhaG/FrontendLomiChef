import 'package:flutter/material.dart';

import '../../../../models/user.dart';
import '../../../../utils/shared_preferences_helper.dart';

class DeliveryOrdersListController {
  BuildContext? context;
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>(); //para poder desplegar el menu de opciones lateral
  late User user;
  late Function refresh;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user')); //datos de usuario guardados
    refresh();
  }

  void logout() {
    if (context == null) {
      print('Error: El contexto no ha sido inicializado.');
      return;
    }
    _sharedPreferencesHelper.logout(context!);
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
}
