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

  // Inicializa el controlador y verifica si el usuario ya tiene una sesión activa.
  Future init(BuildContext context) async {
    this.context = context;
    await usersProvider.init(context);

    /* Intenta recuperar el usuario almacenado en el sharedpreferences, tiene en cuenta
    en este caso la llave 'user'*/
    User user = User.fromJson(await _sharedPreferencesHelper.readSessionToken('user') ?? {});

    //print('Usuario: ${user.toJson()}');

    // Si el token de sesión no es nulo, redirige al usuario al home
    if (user?.sessionToken != null) {
      Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (route) => false);
    }
  }

  // Navega a la página de registro.
  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  // Maneja el proceso de inicio de sesión.
  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Llama al provider de usuarios para autenticar al usuario.
      ResponseApi? responseApi = await usersProvider.login(email, password);

      if (responseApi == null) {
        SnackbarHelper.show(
          context: context,
          message: 'No se pudo procesar la respuesta del servidor.',
          isError: true,
        );
        return;
      }

      // Muestra un mensaje dependiendo del éxito o fracaso del login.
      SnackbarHelper.show(
        context: context,
        message: responseApi.message,
        isError: !responseApi.success,
      );

      if (responseApi.success) {
        // Si el login es exitoso, convierte los datos de respuesta en un objeto User.
        User user = User.fromJson(responseApi.data);

        // Guarda los datos del usuario en sharedpreferences clave 'user'.
        _sharedPreferencesHelper.saveSessionToken('user', user.toJson());

        // Redirige al usuario al home.
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
