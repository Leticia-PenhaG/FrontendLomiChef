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

  UserProvider usersProvider = new UserProvider();

  Future<void> init(BuildContext context) async {
    this.context = context;
    await Future.delayed(Duration.zero); // Simula una operación asíncrona.
    usersProvider.init(context);
  }
  
  void register() async {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text;
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    User user = new User(
      email: email,
      name: name,
      lastname: lastName,
      phone: phone,
      password: password

    );
    
    ResponseApi? responseApi = await usersProvider.create(user); //respuesta del servicio

    print('RESPUESTA: ${responseApi?.toJson()}');

    print('EMAIL: $email');
    print('Name: $name');
    print('lastName: $lastName');
    print('phone: $phone');
    print('password: $password');
    print('confirmPassword: $confirmPassword');
  }
}