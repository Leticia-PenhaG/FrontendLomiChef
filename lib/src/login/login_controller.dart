import 'package:flutter/material.dart';

class LoginController {
  late final BuildContext context;

  Future<void> init(BuildContext context) async {
    this.context = context;
    await Future.delayed(Duration.zero); // Simula una operación asíncrona.
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }
}