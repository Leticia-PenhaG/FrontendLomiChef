import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/models/user.dart';
import 'package:lomi_chef_to_go/src/provider/user_provider.dart';

import '../../models/response_api.dart';
import '../../utils/snackbar_helper.dart';

class LoginController {
  late final BuildContext context;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UserProvider usersProvider = new UserProvider();

  Future init(BuildContext context) async {
    this.context = context;
    await usersProvider.init(context);
    //await Future.delayed(Duration.zero); // Simula una operación asíncrona.
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      // Llamada al proveedor para iniciar sesión
      ResponseApi? responseApi = await usersProvider.login(email, password);

      // Verificar si responseApi es null
      if (responseApi == null) {
        SnackbarHelper.show(
          context: context,
          message: 'No se pudo procesar la respuesta del servidor.',
          isError: true,
        );
        return;
      }

      // Mostrar mensaje basado en la respuesta
      SnackbarHelper.show(
        context: context,
        message: responseApi.message,
        isError: !responseApi.success, // Muestra en rojo si no tiene éxito
      );

      // Imprimir en consola (debugging)
      print('EMAIL: $email');
      print('Password: $password');

      // Si es exitoso, puedes redirigir a otra página
      if (responseApi.success) {
        Navigator.pushReplacementNamed(context, 'home'); // Ajusta la ruta según tu app
      }
    } catch (e) {
      // Manejo de errores y mostrar un mensaje
      SnackbarHelper.show(
        context: context,
        message: 'Ocurrió un error inesperado: ${e.toString()}',
        isError: true,
      );
      print('Error: $e');
    }
  }

}