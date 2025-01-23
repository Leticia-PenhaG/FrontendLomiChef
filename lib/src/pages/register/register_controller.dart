import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';

import '../../models/user.dart';
import '../../provider/user_provider.dart';

class RegisterController {
  late final BuildContext context;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  UserProvider usersProvider = UserProvider();

  Future<void> init(BuildContext context) async {
    this.context = context;
    await Future.delayed(Duration.zero);
    usersProvider.init(context);
  }

  void register() async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    User user = User(
      email: email,
      name: name,
      lastname: lastName,
      phone: phone,
      password: password,
    );

    ResponseApi? responseApi = await usersProvider.create(user); // Respuesta del servicio

    if (responseApi?.success == true) {
      _showDialog('Éxito', 'Usuario registrado correctamente');
    } else {
      _showDialog('Error', responseApi?.message ?? 'Error desconocido');
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    const passwordRegex =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    if (!RegExp(passwordRegex).hasMatch(value)) {
      return 'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tenés que confirmar la contraseña';
    }
    if (value != passwordController.text.trim()) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }
}