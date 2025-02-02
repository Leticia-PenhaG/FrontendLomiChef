import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/utils/shared_preferences_helper.dart';

class ClientProductsListController {
  BuildContext? context;
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>(); //para poder desplegar el menu de opciones lateral

  Future<void> init(BuildContext context) async {
    this.context = context;
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

  void openDrawerNavigator() {
    key.currentState?.openDrawer(); //menu de opciones lateral
  }
}