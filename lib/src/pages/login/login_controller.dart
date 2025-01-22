import 'package:flutter/material.dart';

class LoginController {
  late final BuildContext context;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> init(BuildContext context) async {
    this.context = context;
    await Future.delayed(Duration.zero); // Simula una operación asíncrona.
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('EMAIL: $email');
    print('Password: $password');
  }

}