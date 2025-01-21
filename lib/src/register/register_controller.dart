import 'package:flutter/material.dart';

class RegisterController {
  late final BuildContext context;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> init(BuildContext context) async {
    this.context = context;
    await Future.delayed(Duration.zero); // Simula una operación asíncrona.
  }

  void register() {
    String email = emailController.text.trim();
    String name = nameController.text;
    String lastName = lastNameController.text.trim();
    String phone = phoneController.text;
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    print('EMAIL: $email');
    print('Name: $name');
    print('lastName: $lastName');
    print('phone: $phone');
    print('password: $password');
    print('confirmPassword: $confirmPassword');
  }



}