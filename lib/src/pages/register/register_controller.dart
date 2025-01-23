import 'package:flutter/material.dart';
import 'package:lomi_chef_to_go/src/models/response_api.dart';
import '../../models/user.dart';
import '../../provider/user_provider.dart';

class RegisterController {
  late final BuildContext context;
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  UserProvider usersProvider = UserProvider();

  Future<void> init(BuildContext context) async {
    usersProvider.init(context);
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
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

      //ResponseApi? responseApi = await usersProvider.create(user);

      //print('RESPUESTA: ${responseApi?.toJson()}');
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'El correo es obligatorio';
    const emailRegex =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailRegex).hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Este campo es obligatorio';
    const nameRegex = r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$";
    if (!RegExp(nameRegex).hasMatch(value)) {
      return 'Solo se permiten letras y espacios';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'El teléfono es obligatorio';
    const phoneRegex = r'^\d{9,}$';
    if (!RegExp(phoneRegex).hasMatch(value)) {
      return 'Ingresa un teléfono válido (mínimo 9 dígitos)';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es obligatoria';
    }
    const passwordRegex =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    if (!RegExp(passwordRegex).hasMatch(value)) {
      return 'Debe tener: \n- Al menos 8 caracteres\n- Una mayúscula\n- Una minúscula\n- Un número\n- Un carácter especial.';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}