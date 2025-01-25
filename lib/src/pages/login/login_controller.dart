import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/provider/user_provider.dart';

import '../../models/response_api.dart';
import '../../models/user.dart';
import '../../utils/shared_preferences_helper.dart';
import '../../utils/snackbar_helper.dart';

class LoginController {
  late final BuildContext context;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserProvider usersProvider = new UserProvider();
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();

  Future init(BuildContext context) async {
    this.context = context;
    await usersProvider.init(context);
    // si es null se envía vacío
    User user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user') ?? {});

    print('Usuario: ${user.toJson()}');

    if(user?.sessionToken != null) {
      Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      ResponseApi? responseApi = await usersProvider.login(email, password);

      //print(responseApi?.data);

      if (responseApi == null) {
        SnackbarHelper.show(
          context: context,
          message: 'No se pudo procesar la respuesta del servidor.',
          isError: true,
        );
        return;
      }

      SnackbarHelper.show(
        context: context,
        message: responseApi.message,
        isError: !responseApi.success,
      );

      if (responseApi.success) {
        // Guarda el token de sesión
        User user = User.fromJson(responseApi.data);

        //'user' es la llave con la que se comprueba si ya están guardados los datos
        _sharedPreferencesHelper.saveSessionToken('user', user.toJson());

        Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);

      } else {
        SnackbarHelper.show(
          context: context,
          message: 'Ocurrió un error inesperado: ${responseApi.message}',
          isError: true,
        );
      }
    } catch (e) {
      SnackbarHelper.show(
        context: context,
        message: 'Ocurrió un error inesperado: ${e.toString()}',
        isError: true,
      );
    }
  }
}
